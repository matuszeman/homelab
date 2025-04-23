variable "pve_node" {}
variable "pve_storage" {}
variable "talos_version" {}
variable "talos_additional_extensions" {
  type = list(string)
  default = []
}
variable "name" {}
variable "name_prefix" {
  default = "talos-"
}