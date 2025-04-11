variable "network" {
  type = object({
    name = string
    cidr = string
    domain = string
    nameservers = set(string)
    gateway = string
    dhcp = object({
      enabled = bool
      range = object({
        start = string
        end   = string
      })
    })
    static_ips = map(object({
      address = string
      mac     = optional(string)
    }))
  })
}
