module "vpc" {
  source = "./modules/vpc"
  name   = "my-vpc"
  cidr   = "10.0.0.0/16"
}

module "ec2_instance" {
  source        = "./modules/ec2-instance"
  ami           = var.ami
  instance_type = var.instance_type
  name          = "web-server"
  subnet_id     = module.vpc.public_subnet_id
  vpc_id        = module.vpc.vpc_id
}

