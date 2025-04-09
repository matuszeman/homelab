terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.74.1"
    }
    macaddress = {
      source = "ivoronin/macaddress"
      version = "0.3.2"
    }
    talos = {
      source = "siderolabs/talos"
      version = "0.7.1"
    }
  }
}

