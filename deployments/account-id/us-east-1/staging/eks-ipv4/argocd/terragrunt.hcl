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
  base_source = "${dirname(find_in_parent_folders())}/..//infrastructure/argocd"
}

# Set the location of Terraform configurations
terraform {
  source = local.base_source
}

dependency "eks" {
  config_path = "../cluster"
}

inputs = {
  cluster_name         = dependency.eks.outputs.cluster_name
  argocd_chart_version = "6.2.0"
}