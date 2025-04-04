locals {
  vlans = {
    for id, vlan in var.vlans : id => vlan if id != "1"
  }
}

resource "routeros_interface_vlan" "list" {
  for_each = local.vlans

  interface = routeros_interface_bridge.bridge.name
  name      = "vlan-${each.key}"
  vlan_id   = each.key
  comment = "TF"
}

resource "routeros_interface_bridge_vlan" "list" {
  for_each = local.vlans

  bridge = routeros_interface_bridge.bridge.name
  vlan_ids = [each.key]
  tagged = concat([routeros_interface_bridge.bridge.name], each.value.tagged)
  untagged = each.value.untagged
  comment = "TF"
}