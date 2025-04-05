provider "proxmox" {
  endpoint  = var.proxmox.api_url
  api_token = var.proxmox.api_token

  # Requires SSH key in ~/.ssh/id_rsa on target node.
  ssh {
    agent    = true
    username = "root"
  }
}

