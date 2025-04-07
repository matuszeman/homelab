variable "hostname" {
  type = string
}

variable "nics" {
  type = map(object({
    # creates random one if now specified
    mac: optional(string)
    static_ip = optional(string)
    route_metric = optional(number, 0)
    network: object({
      nameservers = set(string)
      gateway = string
      cidr = string
    })
  }))
}
