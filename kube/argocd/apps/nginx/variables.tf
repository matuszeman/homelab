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

variable "helm_values_override" {
  type = any
  default = {}
}