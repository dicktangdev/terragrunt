output "elasticache_arm" {
  value = aws_elasticache_cluster.single.arn
}

output "elasticache_info" {
  value = aws_elasticache_cluster.single.cache_nodes
}