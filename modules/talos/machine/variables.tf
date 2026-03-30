#variable "hostname" {}
variable "ip" {}
variable "nics" {}
variable "cluster_config" {}
variable "kubernetes_version" {}
variable "bootstrap" {
  type = bool
  default = false
}
variable "talos_image" {}
variable "install_disk" {}
variable "talos_machine_type" {
  type = string
}
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
