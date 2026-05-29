variable "ctx" {}
variable "name" {}
variable "ports" {
  type = map(object({
    comment = optional(string)
    vlan_access_port = optional(number)
    vlan_trunk_port  = optional(list(number))
    vlan_hybrid_port = optional(object({
      native_vlan  = number
      tagged_vlans = list(number)
    }))
  }))
}
variable "vlan_filtering" {
  type = bool
}
