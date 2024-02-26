variable "repo_name" {
  type        = string
  description = "The repo name"
}

variable "mutability" {
  type        = string
  description = "The repo mutability"
  default = "MUTABLE"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the VPC resources"
  default = {
    Terragrunt  = "true"
    Environment = "dev"
  }
}