variable "argocd" {
  type = object({
    namespace = string
    app_prefix = optional(string)
    preserve_resources_on_deletion: optional(bool, false)
    autosync = optional(bool, true)
    autosync_prune = optional(bool, true)
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

variable "values_object_override" {
  type = any
  default = {}
}

variable "namespace" {
  type    = string
}
