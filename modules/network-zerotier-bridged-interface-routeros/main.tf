resource "routeros_zerotier_interface" "this" {
  allow_default = false
  allow_global  = false
  allow_managed = false
  instance      = var.instance_name
  name          = var.interface_name
  network       = var.zerotier_network.id
}

resource "zerotier_member" "this" {
  name                    = "ros-${var.instance_name}-${var.interface_name}"
  member_id               = var.member_id
  network_id              = var.zerotier_network.id
  authorized              = true
  description             = "tf"
  hidden                  = false
  allow_ethernet_bridging = true
  no_auto_assign_ips      = true
  ip_assignments          = [var.zerotier_network.network.gateway]
}
