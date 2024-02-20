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
  base_source = "${dirname(find_in_parent_folders())}/..//infrastructure/vpc"
  # merged_tags = merge(
  #   local.base_source.tags,
  #   {
  #     Environment = "dev"
  #     Application = "my-app"
  #   }
  # )
}

# Set the location of Terraform configurations
terraform {
  source = local.base_source
}

inputs = {
  name            = "xxx"
  cidr            = "xxx"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["xxx", "xxx", "xxx"]
  public_subnets  = ["xxx", "xxx", "xxx"]
  private_subnet_tags = {
    "karpenter.sh/discovery"              = "lxxx", # this tag need to apply before cluster creation. it is for karpenter subnet selection, value should be the cluster name that will create later
    "kubernetes.io/role/internal-elb"     = "1",
    "kubernetes.io/cluster/xxx" = "owned"
  }
  public_subnet_tags = {
    "kubernetes.io/role/elb"              = "1",
    "kubernetes.io/cluster/xxx" = "owned"
  }
}