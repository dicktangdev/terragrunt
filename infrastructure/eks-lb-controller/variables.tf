variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "eks_cluster_oidc_issuer_url" {
  type        = string
  description = "EKS cluster_oidc_issuer_url"
}

variable "eks_oidc_provider_arn" {
  type        = string
  description = "EKS eks_oidc_provider_arn"
}
