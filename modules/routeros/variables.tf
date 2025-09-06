variable "name" {}

# variable "networks" {
#   type = map(object({
#     vlan = optional(number)
#   }))
# }
variable "bridge" {
  type = object({
    ports = map(object({
      vlan_access_port = optional(string)
      vlan_trunk_port  = optional(list(number))
      #interface = string
    }))
  })
}
variable "wan" {
  type = object({
    interface = string
  })
}

variable "vlan_filtering" {
  type = bool
}
