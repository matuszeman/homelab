# routeros
variable "interface_ip" {}
variable "interface_name" {}
variable "bridge_name" {}

# zerotier
variable "zerotier_instance" {
  type = object({
    name      = string
    member_id = string
  })
}
variable "zerotier_member_name" {}
variable "zerotier_network" {
  type = object({
    id = string
    cidr = string
  })
}
