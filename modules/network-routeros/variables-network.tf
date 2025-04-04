variable "name" {
  type = string
}
variable "domain" {
  description = "Unique network/domain name"
}
variable "nameservers" {
  type = set(string)
}
variable "default_gateway" {}

variable "network" {}
variable "dhcp" {
  type = bool
}
variable "dhcp_range" {
  type = object({
    start = string
    end = string
  })
  default = null
}

variable "static_ip_allocations" {
  type = map(object({
    address = string
    mac = string
  }))
}

variable "address_pools" {
  type = any
}
