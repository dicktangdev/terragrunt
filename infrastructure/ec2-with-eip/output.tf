output "private_key" {
  value     = tls_private_key.key.private_key_pem
  sensitive = true
}

output "instance_id" {
  value = module.ec2_instance.id
}

output "private_ip" {
  value = aws_eip.eip.private_ip
}

output "public_ip" {
  value = aws_eip.eip.public_ip
}