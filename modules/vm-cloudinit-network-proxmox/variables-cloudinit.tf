variable "hostname" {
  type = string
  default = null
}

variable "nics" {
  type = map(object({
    # creates random one if now specified
    mac: optional(string)
    static_ip = optional(string)
    network: object({
      nameservers = set(string)
      gateway = string
      cidr = string
    })
  }))
}
