variable "cluster_config" {
  type = object({
    cluster_name = string
    machine_secrets = any
    client_configuration = any
    cluster_endpoint = string
    allow_scheduling_on_control_planes = bool
    network = object({
      cidr = string
    })
    vip_ip = string
  })
}
variable "machine_type" {
  type = string
}
variable "install_disk" {}
variable "install_image" {}
variable "vip_nic" {
  type = object({
    mac: string
  })
}
#variable "node_ip" {}