variable "argocd" {}
variable "release" {}
variable "namespace" {
  type = string
}
variable "manage_crds" {
  type = bool
}

variable "dry_run" {
  type = bool
}

variable "default_target" {
  type = string
  default = null
}

variable "ingress_class_filters" {
  type = list(string)
}

variable "sealed_secrets" {
  type = object({
    cloudflare_api_token = string
  })
}