variable "argocd" {
  type = object({
    namespace = string
    preserve_resources_on_deletion: optional(bool, false)
  })
}

variable "chart_version" {
  type = string
}

variable "skip_crds" {
  type = bool
  default = false
}

variable "release" {
  type    = string
}

variable "repo_url" {
  type    = string
}

variable "chart" {}

variable "values_object" {
  type = any
  default = {}
}

variable "namespace" {
  type    = string
}
