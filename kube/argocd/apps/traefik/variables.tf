variable "metallb" {
  type = object({
    ip = string
  })
}
variable "release" {}
variable "argocd" {}
variable "namespace" {
  type = string
}
