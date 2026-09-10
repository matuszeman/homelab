resource "routeros_zerotier_interface" "this" {
  allow_default = false
  allow_global  = false
  allow_managed = false
  instance      = var.zerotier_instance.name
  name          = "zt-${var.network.name}"
  comment       = var.interface_comment
  network       = var.zerotier_network.id
}

resource "zerotier_member" "this" {
  name                    = var.zerotier_member_name
  member_id               = var.zerotier_instance.member_id
  network_id              = var.zerotier_network.id
  authorized              = true
  description             = "tf"
  hidden                  = false
  allow_ethernet_bridging = var.allow_ethernet_bridging
  no_auto_assign_ips      = true
  ip_assignments          = [var.network.gateway]
}
