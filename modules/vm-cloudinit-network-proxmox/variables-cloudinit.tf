variable "hostname" {
  type = string
  default = null
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
