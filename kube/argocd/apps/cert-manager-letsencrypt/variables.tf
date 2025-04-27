variable "argocd" {}
variable "release" {}
variable "namespace" {
  type = string
}
variable "manage_crds" {
  type = bool
}
variable "helm_values_override" {
  type = any
  default = {}
}

variable "cluster_issuer_staging" {}
variable "cluster_issuer" {}

variable "letsencrypt" {
  type = object({
    email = string
  })
}
variable "dns_resolver" {
  type = object({
    cloudflare = object({
      email: string
    })
  })
}
variable "sealed_secrets" {
  type = object({
    cloudflare_api_token = string
  })
}