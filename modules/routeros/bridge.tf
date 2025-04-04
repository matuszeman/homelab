resource "routeros_interface_bridge" "bridge" {
  name           = "bridge"
  comment = "TF"
  vlan_filtering = var.vlan_filtering
}

resource "routeros_interface_bridge_port" "ports" {
  for_each = var.bridge.ports
  bridge    = routeros_interface_bridge.bridge.name
  comment = "TF"
  interface = each.key
  pvid      = each.value.vlan
}

