terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_key_pair" "test_key" {
    public_key = file("/home/ubuntu/.ssh/id_ed25519.pub")
}
resource "aws_security_group" "ssh-access_tf_05" {
    name        = "ssh-access_tf_05"
    description = "Allow ssh accesss from internet"
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
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
}
resource "aws_instance" "test_tf_creation" {
    ami = "ami-0360c520857e3138f"
    instance_type = "t2.medium"
    key_name = aws_key_pair.test_key.id
    vpc_security_group_ids = [aws_security_group.ssh-access_tf_05.id]
    tags = {
        name = "terraform_tf_state"
        Description = "terraform practice on ubuntu"
    }

}

output publicip {
    value           = aws_instance.test_tf_creation.public_ip
}
