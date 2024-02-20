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
  base_source = "${dirname(find_in_parent_folders())}/..//infrastructure/s3"
}

# Set the location of Terraform configurations
terraform {
  source = local.base_source
}

dependency "vpc" {
  config_path = "../../eks-ipv4/vpc"
}

inputs = {
  bucket_name = "lxxxx"
  subfolder_keys = [
    "xxx/file/",
  ]
  acl = "private"
}