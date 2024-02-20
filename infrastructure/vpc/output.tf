output "vpc_name" {
  value = module.vpc.name
}

output "secondary_cidr_blocks" {
  value = module.vpc.vpc_secondary_cidr_blocks
}
output "public_subnets_id" {
  value = module.vpc.public_subnets
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "default_security_group_id" {
  value = module.vpc.default_security_group_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "azs" {
  value = module.vpc.azs
}
