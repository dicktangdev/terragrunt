output "ecs_cluster" {
  value = aws_ecs_cluster.wiretrustee.name
}

output "ecs_autoscaling_group" {
  value = aws_autoscaling_group.wiretrustee.name
}

output "private_key" {
  value     = tls_private_key.key.private_key_pem
  sensitive = true
}