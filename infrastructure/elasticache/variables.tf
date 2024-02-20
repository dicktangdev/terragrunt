variable "vpc_id" {
  type        = string
  description = "The id of the VPC"
}

variable "subnet_group_name" {
  type        = string
  description = "The name of the subnet group"
}

variable "cluster_id" {
  type        = string
  description = "The name of the cluster"
}

variable "node_type" {
  type        = string
  description = "The node type of the redis"
}

variable "vpc_default_security_group_id" {
  type        = string
  description = "The vpc default sg id"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the VPC resources"
  default = {
    Terragrunt  = "true"
    Environment = "dev"
  }
}