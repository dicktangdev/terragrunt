output "db_instance_address" {
  value = module.mysql.db_instance_address
}

output "db_instance_arn" {
  value = module.mysql.db_instance_arn
}

output "db_instance_identifier" {
  value = module.mysql.db_instance_identifier
}

# output "db_instance_username" {
#   value = module.mysql.db_instance_username
#   sensitive = true
# }

output "db_instance_master_user_secret_arn" {
  value = module.mysql.db_instance_master_user_secret_arn
}