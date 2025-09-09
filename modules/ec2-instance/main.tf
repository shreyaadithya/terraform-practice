resource "aws_key_pair" "test_key" {
    public_key = file("/home/ubuntu/.ssh/id_ed25519.pub")
}

resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sg"
  }
}

resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.test_key.id
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]

  tags = {
    Name = var.name
  }
}

# Null resource replaces user_data
resource "null_resource" "install_httpd" {
  depends_on = [aws_instance.this]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_ed25519")   # private key used to connect
      host        = aws_instance.this.public_ip # instance public IP
    }

    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd",
      "echo '<h1>Hello from Terraform Null Resource!</h1>' | sudo tee /var/www/html/index.html"
    ]
  }
}

