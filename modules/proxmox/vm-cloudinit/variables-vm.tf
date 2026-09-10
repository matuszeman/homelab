variable "name" {
  description = "Unique name"
}

variable "root_volume_size_gb" {
  description = "Volume size in GB"
}

variable "data_volumes" {
  type = list(object({
    size_gb   = number
    interface = string
  }))
  default = []
}

variable "memory_gb" {
  description = "Memory size in GB"
}

variable "vcpu" {
  type = number
}

variable "nics" {
  type = any
}

