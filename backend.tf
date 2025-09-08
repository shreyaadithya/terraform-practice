terraform {
  backend "s3" {
    bucket         = "my-terraform-stbucket"
    key            = "ec2/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locking"
  }
}

