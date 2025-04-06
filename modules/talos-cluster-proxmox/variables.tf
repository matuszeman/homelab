variable "proxmox" {
  description = "Proxmox node configuration."
  type = object({
    node_name   = string
  })
}

variable "talos"{
  description = "Talos configuration."
  type = object({
    cluster_endpoint = string
    cluster_name     = string
    version          = string
    image_hash       = string
  })
}

variable "vm_params" {
  description = "A map of parameters for the VMs."
  type = map(object({
    cpu_cores    = number
    disk_size    = number
    role         = string
    ip_address   = string
    gateway      = string
    memory       = number
    tags         = list(string)
  }))
}

