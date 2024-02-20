variable "aws_region" {
  type        = string
  description = "Get the aws region"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster."
}

variable "cluster_version" {
  type        = string
  description = "Version of the EKS cluster."
  default     = "1.29"
}

variable "public_access" {
  type        = bool
  description = "Whether or not to enable public access to the EKS cluster endpoint."
  default     = false
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the EKS cluster will be deployed."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs where the EKS nodes will be deployed."
}

variable "control_plane_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs where the EKS control plane will be deployed."
}

variable "eks_managed_node_groups_instance_types" {
  type        = string
  description = "The eks node group instance type"
}

variable "aws_auth_roles" {
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  description = "List of IAM roles to include in the aws-auth configmap."
  default     = []
}

variable "aws_auth_users" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default     = []
  description = "List of IAM users to include in the aws-auth configmap."
}

variable "aws_auth_accounts" {
  type        = list(string)
  description = "List of AWS account IDs to include in the aws-auth configmap."
  default     = []
}

variable "coredns_selector" {
  type = object({
    nodeSelector : map(string)
  })
}

variable "min_size" {
  type        = number
  description = "min_size of the managed nodes."
}

variable "desired_size" {
  type        = string
  description = "desired_size of the managed nodes."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources created by this module."
}



