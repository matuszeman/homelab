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
