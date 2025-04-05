variable "proxmox" {
  description = "Proxmox node configuration."
  type = object({
    node_name   = string
    api_url     = string
    api_token   = string
  })
}

variable "vm_params" {
  description = "A map of parameters for the VMs."
  type = map(object({
    cpu_cores    = number
    disk_size    = number
    k8s_role     = string
    install_disk = optional(string)
    ip_address   = optional(string)
    memory       = number
    tags         = list(string)
  }))
}

