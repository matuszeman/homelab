variable "name" {
  description = "Unique name"
}

variable "root_volume_size_gb" {
  description = "Volume size in GB"
}

variable "memory_gb" {
  description = "Memory size in GB"
}

variable "vcpu" {
  type = number
}
