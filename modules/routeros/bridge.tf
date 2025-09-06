resource "routeros_interface_bridge" "bridge" {
  name           = "bridge"
  comment        = "TF"
  vlan_filtering = var.vlan_filtering
}

resource "routeros_interface_bridge_port" "ports" {
  for_each  = var.bridge.ports
  bridge    = routeros_interface_bridge.bridge.name
  comment   = "TF"
  interface = each.key
  # Ensure PVID is set as a number, not string
  pvid      = each.value.vlan_access_port != null ? tonumber(each.value.vlan_access_port) : 1
  # Set frame_types based on port type:
  # - Access ports: admit only untagged and priority-tagged frames
  # - Trunk ports: admit only VLAN-tagged frames
  # - Neither: admit all frame types
  frame_types = each.value.vlan_access_port != null ? "admit-only-untagged-and-priority-tagged" : (each.value.vlan_trunk_port != null ? "admit-only-vlan-tagged" : "admit-all")
  # https://youtu.be/YMwOrc0LDP8?si=b4-1-oOq7ev8d-0l&t=450
  ingress_filtering = true
}
