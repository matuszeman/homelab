variable "hostname" {
  type = string
}

variable "nics" {
  type = list(object({
    name: string
    mac: string
    static_ip = optional(string)
    network: object({
      nameservers = set(string)
      gateway = string
      cidr = string
    })
  }))
}
