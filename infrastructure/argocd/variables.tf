variable "admin_password" {
  default = ""
}
# To get the self-generated admin password:
# kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster."
}

variable "argocd_chart_version" {
  type        = string
  description = "argocd chart version"
}