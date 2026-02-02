variable "release" {}
variable "namespace" {}
variable "helm_version" {
  # keep in sync with kube/apps/argocd/helm/Chart.yaml version
  default = "9.3.7"
}