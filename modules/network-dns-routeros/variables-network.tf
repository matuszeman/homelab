variable "network" {
  type = object({
    name = string
    domain = string
    static_ips = map(object({
      address = string
      mac     = string
    }))
  })
}
