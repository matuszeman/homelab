resource "proxmox_virtual_environment_vm" "this" {
  for_each  = var.vm_params
  name      = each.key
  node_name = var.proxmox.node_name
  tags      = each.value["tags"]

  cpu {
    cores = each.value["cpu_cores"]
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value["memory"]
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    cache       = "writethrough"
    file_id     = proxmox_virtual_environment_download_file.talos_image.id
    file_format = "raw"
    interface   = "scsi0"
    size        = each.value["disk_size"]
    ssd         = true
  }

  operating_system {
    type = "l26"
  }

  # Cloud-int configuration
  initialization {
    ip_config {
      ipv4 {
        address = "${each.value["ip_address"]}/24"
        gateway = "${each.value["gateway"]}"
      }
    }
  }
}
