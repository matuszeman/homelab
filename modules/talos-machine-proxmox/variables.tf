variable "pve_node" {}
variable "pve_cloudinit_storage" {}

variable "cluster_config" {}
variable "bootstrap" {
  type = bool
  default = false
}
variable "talos_version" {}
variable "talos_image_versions" {
  type = map(object({
    iso_file_id = string
    installer = string
  }))
}
variable "talos_machine_type" {
  type = string
}
variable "vip_nic" {}
variable "nics" {
  type = any
}