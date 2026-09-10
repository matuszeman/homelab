variable "in_interface_list" {}
variable "port_forwards" {
  type = map(object({
    port: number
    protocol: optional(string, "tcp")
    enabled: optional(bool, true)
    log: optional(bool, false)
    log_prefix: optional(string, "")
  }))
}
variable "public_address" {}
variable "hairpin" {
  type = object({
    enabled = optional(bool, true)
    network = object({
      cidr: string
    })
  })
  default = null
}
variable "server_address" {}
