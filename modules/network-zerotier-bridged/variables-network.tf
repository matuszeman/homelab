variable "network" {
  type = object({
    name = string
    cidr = string
    domain = string
    nameservers = set(string)
    gateway = string
    address_pools = map(object({
      cidr = optional(string)
      range = optional(object({
        start = string
        end = string
      }))
    }))
    dhcp_server = optional(string)
    static_ips = map(object({
      address = string
      zerotier_member = optional(object({
        id = string
        authorized = bool
      }))
    }))
  })
}
