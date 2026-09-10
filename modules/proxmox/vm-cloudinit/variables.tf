variable "ctx" {}

variable "vm_id" {
  type = number
}
variable "pve_node" {}
variable "pve_cloudinit_storage" {}
variable "pve_iso_file_id" {}
variable "machine" {
  default = "q35"
}
variable "scsi_hardware" {
  default = "virtio-scsi-single"
}
