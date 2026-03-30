output "nics" {
  value = local.nics
}

output "disks" {
  value = {
    root = {
      interface = "virtio0"
      path = "/dev/vda"
    }
  }
}

output "cdrom" {
  value = {
    interface = "ide0"
  }
}
