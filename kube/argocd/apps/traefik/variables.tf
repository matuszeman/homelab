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
variable "monitoring_services" {
  type = object({
    metrics = object({
      otlp_grpc = object({
        host = string
        port = number
      })
    })
  })
}