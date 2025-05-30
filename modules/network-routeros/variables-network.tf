variable "dhcp_address_pool" {
  type = string
  default = "dhcp"
}

variable "network" {
  type = object({
    name = string
    cidr = string
    domain = string
    nameservers = set(string)
    gateway = string
    dhcp_server = optional(string)
    address_pools = map(object({
      cidr = optional(string)
      range = optional(object({
        start = string
        end = string
      }))
    }))
    static_ips = map(object({
      address = string
      mac     = optional(string)
    }))
  })
}
