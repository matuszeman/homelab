resource "routeros_zerotier_interface" "this" {
  allow_default = false
  allow_global  = false
  allow_managed = false
  instance      = var.zerotier_instance.name
  name          = var.interface_name
  network       = var.zerotier_network.id
}

resource "routeros_interface_bridge_port" "this" {
  bridge    = var.bridge_name
  comment   = "tf"
  interface = routeros_zerotier_interface.this.name
  # TODO
  #pvid      = each.value.vlan
}

resource "zerotier_member" "this" {
  name                    = var.zerotier_member_name
  member_id               = var.zerotier_instance.member_id
  network_id              = var.zerotier_network.id
  authorized              = true
  description             = "tf"
  hidden                  = false
  allow_ethernet_bridging = true
  no_auto_assign_ips      = true
  ip_assignments          = [var.interface_ip]
}
