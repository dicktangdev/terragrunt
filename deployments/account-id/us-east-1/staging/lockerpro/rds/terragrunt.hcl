/******************************
TERRAGRUNT CONFIGURATIONS
******************************/

# Include the root terragrunt.hcl configurations gathering together
# the needed variables and backend configurations
include "root" {
  path = find_in_parent_folders()
}

locals {
  # Expose the base source path so different versions of the module can be deployed in different environments
  base_source = "${dirname(find_in_parent_folders())}/..//infrastructure/rds-mysql"
}

# Set the location of Terraform configurations
terraform {
  source = local.base_source
}

dependency "vpc" {
  config_path = "../../eks-ipv4/vpc"
}

inputs = {
  vpc_id                = dependency.vpc.outputs.vpc_id
  multi_az              = true
  identifier            = "xxxx"
  instance_class        = "db.t4g.micro"
  allocated_storage     = 50
  max_allocated_storage = 200
  parameter_group_name  = "xxx-pg"
  option_group_name     = "xxx-og"
  username              = "xxx"
  public_subnet_ids     = dependency.vpc.outputs.public_subnets_id

}