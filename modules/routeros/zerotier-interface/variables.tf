# routeros
variable "network" {}
variable "interface_comment" {}
variable "allow_ethernet_bridging" {
  type    = bool
  default = false
  description = "Enable for bridged mode"
}

# zerotier
variable "zerotier_member_name" {}
variable "zerotier_instance" {
  type = object({
    name      = string
    member_id = string
  })
}
variable "zerotier_network" {
  type = object({
    id = string
    cidr = string
  })
}
