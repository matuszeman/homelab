variable "ctx" {}
variable "name" {}
variable "ports" {
  type = map(object({
    vlan_access_port = optional(number)
    vlan_trunk_port  = optional(list(number))
  }))
}
variable "vlan_filtering" {
  type = bool
}
