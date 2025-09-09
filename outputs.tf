output "ec2_instance_public_ip" {
  value = module.ec2_instance.public_ip
}

output "ec2_instance_web_url" {
  value = "http://${module.ec2_instance.public_ip}"
}

