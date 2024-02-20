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
  base_source = "${dirname(find_in_parent_folders())}/..//infrastructure/eks"
}

# Set the location of Terraform configurations
terraform {
  source = local.base_source
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  cluster_name                           = "xxxx"
  cluster_version                        = "1.29"
  min_size                               = 2
  desired_size                           = 2
  public_access                          = true
  vpc_id                                 = dependency.vpc.outputs.vpc_id
  subnet_ids                             = dependency.vpc.outputs.private_subnets
  control_plane_subnet_ids               = dependency.vpc.outputs.private_subnets
  eks_managed_node_groups_instance_types = "t3.xlarge"
  coredns_selector = {
    nodeSelector = {
      corenode : "True"
    }
  }
  aws_auth_users = [
    {
      userarn  = "xxxx"
      username = "xxxxx"
      groups   = ["system:masters"]
    },
  ]
}