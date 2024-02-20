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
  base_source = "${dirname(find_in_parent_folders())}/..//infrastructure/sqs"
}

# Set the location of Terraform configurations
terraform {
  source = local.base_source
}

inputs = {
  sqs_name                   = "xxx_dlq"
  create_dlq                 = false
  fifo_queue                 = false
  message_retention_seconds  = 604800
  visibility_timeout_seconds = 100
  max_message_size           = 262144
  receive_wait_time_seconds  = 3
}
