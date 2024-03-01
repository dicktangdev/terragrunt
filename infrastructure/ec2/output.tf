output "private_key" {
  value     = tls_private_key.key.private_key_pem
  sensitive = true
}

output "instance_id" {
  value = module.ec2_instance.id
}