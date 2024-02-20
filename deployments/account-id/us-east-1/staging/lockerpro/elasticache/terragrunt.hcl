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
  base_source = "${dirname(find_in_parent_folders())}/..//infrastructure/elasticache"
}

# Set the location of Terraform configurations
terraform {
  source = local.base_source
}

dependency "vpc" {
  config_path = "../../eks-ipv4/vpc"
}

inputs = {
  vpc_id                        = dependency.vpc.outputs.vpc_id
  subnet_group_name             = "xxxx"
  cluster_id                    = "xxxx"
  node_type                     = "cache.t4g.micro"
  vpc_default_security_group_id = dependency.vpc.outputs.default_security_group_id
}