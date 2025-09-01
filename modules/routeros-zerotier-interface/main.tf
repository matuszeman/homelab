resource "routeros_zerotier_interface" "this" {
  allow_default = false
  allow_global  = false
  allow_managed = false
  instance      = var.zerotier_instance.name
  name          = var.interface_name
  comment       = var.interface_comment
  network       = var.zerotier_network.id
}

resource "routeros_ip_address" "this" {
  comment   = "tf: zerotier ${var.zerotier_member_name} ip"
  address   = "${var.interface_ip}/${split("/", var.zerotier_network.cidr)[1]}"
  interface = routeros_zerotier_interface.this.name
}

resource "zerotier_member" "this" {
  name                    = var.zerotier_member_name
  member_id               = var.zerotier_instance.member_id
  network_id              = var.zerotier_network.id
  authorized              = true
  description             = "tf"
  hidden                  = false
  allow_ethernet_bridging = false
  no_auto_assign_ips      = true
  ip_assignments          = [var.interface_ip]
}
