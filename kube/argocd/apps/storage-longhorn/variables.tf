variable "release" {}
variable "argocd" {}
variable "namespace" {
  type = string
}
variable "manage_crds" {
  type = bool
}
variable "ingress" {
  type = object({
    enabled = bool
    host = string
    controller = object({
      class_name = string
      annotations = map(string)
    })
    cert_manager_cluster_issuer = string
  })
}