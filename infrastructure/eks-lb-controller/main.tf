module "load_balancer_controller" {
  source = "DNXLabs/eks-lb-controller/aws"

  enabled = true

  cluster_identity_oidc_issuer     = var.eks_cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = var.eks_oidc_provider_arn
  cluster_name                     = var.cluster_name

}