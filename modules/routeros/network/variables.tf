variable "ctx" {}

variable "disabled" {
  default = false
}
variable "interface" {
  type = string
}

variable "dhcp_server" {
  type = object({
    adress_pool_name = string
    lease_time       = optional(string)
    ntp_server_ips   = optional(list(string), [])
    dhcp_options     = optional(list(object({
      code  = number
      name  = string
      value = string
    })), [])
  })
  default = null
}
