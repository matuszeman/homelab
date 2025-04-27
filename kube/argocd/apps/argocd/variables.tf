variable "release" {}
variable "namespace" {
  type = string
}
variable "helm_values_override" {
  type = any
  default = {}
}
variable "ingress" {
  type = object({
    domain = string
    class = string
    cert_manager_cluster_issuer = string
  })
}

variable "repos" {
  type = map(object({
    type = string
    url = string
    # project = string
  }))
}

variable "repo_creds" {
  type = map(object({
    type = string
    url = string
    # project = string
    sealedSecrets: object({
      sshPrivateKey: string
    })
  }))
}