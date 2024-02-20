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
  base_source = "${dirname(find_in_parent_folders())}/..//infrastructure/eks-lb-controller"
}

# Set the location of Terraform configurations
terraform {
  source = local.base_source
}

dependency "eks" {
  config_path = "../cluster"
}

inputs = {
  cluster_name                = dependency.eks.outputs.cluster_name
  eks_cluster_oidc_issuer_url = dependency.eks.outputs.all_eks_outputs.cluster_oidc_issuer_url
  eks_oidc_provider_arn       = dependency.eks.outputs.all_eks_outputs.oidc_provider_arn
}