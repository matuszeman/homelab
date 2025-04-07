output "file_id" {
  value = proxmox_virtual_environment_file.this.id
}

output "nics" {
  value = module.cloudinit.nics
}