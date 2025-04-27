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
variable "monitoring" {
  type = object({
    logs = object({
      access = object({
        enabled = optional(bool, false)
      })
    })
    metrics = object({
      enabled = optional(bool, false)
    })
    traces = object({
      enabled = optional(bool, false)
    })
    backends = object({
      metrics = object({
        otlp_grpc = object({
          host = string
          port = number
        })
      })
      traces = object({
        otlp_grpc = object({
          host = string
          port = number
        })
      })
    })
  })
}

variable "helm_values_override" {
  type = any
  default = {}
}