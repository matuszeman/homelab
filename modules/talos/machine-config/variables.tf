variable "cluster_config" {
  type = object({
    cluster_name = string
    machine_secrets = any
    client_configuration = any
    cluster_endpoint = string
    allow_scheduling_on_control_planes = bool
    metrics_server_enabled = bool
    network = object({
      cidr = string
    })
    vip_ip = string
    vip_dns = string
    registries_config = any
    oidc = optional(object({
      issuer_url      = string
      client_id       = string
      username_claim  = optional(string)
      groups_claim    = optional(string)
      username_prefix = optional(string)
      groups_prefix   = optional(string)
    }))
  })
}
# https://docs.siderolabs.com/talos/v1.12/getting-started/support-matrix
variable "kubernetes_version" {}
variable "machine_type" {
  type = string
}
variable "bootstrap" {
  type = bool
}
variable "install_disk" {}
variable "install_image" {}
#variable "hostname" {}
variable "nics" {
  type = map(object({
    mac: string
    #static_ip = optional(string)
    #route_metric = optional(number, 0)
    network: object({
      #nameservers = set(string)
      #gateway = string
      cidr = string
    })
  }))
}
# https://www.talos.dev/v1.9/reference/configuration/v1alpha1/config/#Config.machine
variable "node_labels" {
  type = map(string)
  default = {}
}
variable "node_annotations" {
  type = map(string)
  default = {}
}
variable "node_taints" {
  type = map(string)
  default = {}
}
variable "extra_mounts" {
  type = list(object({
    destination = string
    source      = string
    type        = string
    options     = list(string)
  }))
  default = []
}
variable "extra_config_patches" {
  type        = list(string)
  default     = []
  description = "Additional raw YAML config patches (e.g. UserVolumeConfig)"
}
