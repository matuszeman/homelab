resource "routeros_interface_bridge" "bridge" {
  name           = var.name
  comment        = format(local.comment_format, "")
  vlan_filtering = var.vlan_filtering
  #frame_types = var.vlan_filtering ? "admit-all" :
}

resource "routeros_interface_bridge_port" "ports" {
  for_each  = var.ports
  bridge    = routeros_interface_bridge.bridge.name
  comment   = each.value.comment != null ? format(local.comment_format, each.value.comment) : format(local.comment_format, "")
  interface = each.key
  # Ensure PVID is set as a number, not string
  pvid      = each.value.vlan_access_port != null ? each.value.vlan_access_port : (each.value.vlan_hybrid_port != null ? each.value.vlan_hybrid_port.native_vlan : 1)
  # Set frame_types based on port type:
  # - Access ports: admit only untagged and priority-tagged frames
  # - Trunk ports: admit only VLAN-tagged frames
  # - Neither: admit all frame types
  frame_types = each.value.vlan_access_port != null ? "admit-only-untagged-and-priority-tagged" : (each.value.vlan_trunk_port != null ? "admit-only-vlan-tagged" : "admit-all")
  # https://youtu.be/YMwOrc0LDP8?si=b4-1-oOq7ev8d-0l&t=450
  ingress_filtering = true
}
