variable "argocd" {}
variable "namespace" {
  type = string
}
variable "release" {}
variable "cluster_name" {}
variable "sealed_secrets" {
  type = object({
    access_token = string
    prometheus_username = string
    loki_username = string
    tempo_username = string
    pyroscope_username = string
  })
}
variable "helm_values_override" {
  type = any
  default = {}
}