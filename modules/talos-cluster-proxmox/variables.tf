variable "proxmox" {
  description = "Proxmox node configuration."
  type = object({
    node_name = string
  })
}

variable "talos" {
  description = "Talos configuration."
  type = object({
    cluster_endpoint = string
    cluster_name     = string
    version          = string
    image_hash       = string
  })
}

variable "talos_config" {
  description = "Talos configuration."
  type = object({
    allow_scheduling_on_control_planes = bool
    kubelet_rotate_certificates = bool
    enable_metric_server = bool
  })
  default = {
    allow_scheduling_on_control_planes = false
    kubelet_rotate_certificates = false
    enable_metric_server = false
  }
}

variable "vm_params" {
  description = "A map of parameters for the VMs."
  type = map(object({
    cpu_cores  = number
    disk_size  = number
    role       = string
    ip_address = string
    gateway    = string
    memory     = number
    tags       = list(string)
  }))
}

