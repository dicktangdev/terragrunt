variable "karpenter_version" {
  type        = string
  description = "karpenter_version"
  default     = "v0.29.0"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "environment" {
  type        = string
  description = "Current envrionment name"
}

variable "aws_region" {
  type        = string
  description = "Current aws region name"
}

variable "eks_worker_iam_role" {
  type        = string
  description = "EKS worker node IAM role"
}

variable "env" {
  description = "Environment for provisioning manifests"
  type        = string
}

# variable "ttlSecondsUntilExpired" {
#   type    = number
#   default = null # 30days for dev, disable for prod
# }
