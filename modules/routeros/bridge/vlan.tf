# VLAN docs
# https://help.mikrotik.com/docs/spaces/ROS/pages/88014957/VLAN

locals {
  # Get all access port names for filtering
  access_port_names = toset([
    for port_name, port_config in var.ports : port_name
    if port_config.vlan_access_port != null
  ])

  # Collect all VLAN IDs from access ports
  access_vlans = {
    for port_name, port_config in var.ports :
    port_config.vlan_access_port => {
      tagged   = []
      untagged = [port_name]
    }...
    if port_config.vlan_access_port != null
  }

  # Flatten grouped access VLANs to combine multiple ports with same VLAN ID
  access_vlans_flattened = {
    for vlan_id, vlan_groups in local.access_vlans : vlan_id => {
      tagged   = []
      untagged = flatten([for group in vlan_groups : group.untagged])
    }
  }

  # Get all trunk VLAN IDs
  all_trunk_vlans = flatten([
    for port_name, port_config in var.ports :
    port_config.vlan_trunk_port != null ? port_config.vlan_trunk_port : []
  ])

  # Collect all trunk VLAN IDs and group ports by VLAN
  # Always exclude access ports from tagged lists
  trunk_vlans = {
    for vlan_id in distinct(local.all_trunk_vlans) : vlan_id => {
      tagged = [
        for port_name, port_config in var.ports : port_name
        if port_config.vlan_trunk_port != null &&
           contains(coalesce(port_config.vlan_trunk_port, []), vlan_id) &&
           !contains(local.access_port_names, port_name)
      ]
      untagged = []
    }
  }

  # Merge access and trunk VLANs, ensuring access ports remain untagged
  vlans = {
    for vlan_id in distinct(concat(keys(local.access_vlans_flattened), keys(local.trunk_vlans))) : vlan_id => {
      tagged = lookup(local.trunk_vlans, vlan_id, { tagged = [] }).tagged
      untagged = concat(
        lookup(local.access_vlans_flattened, vlan_id, { untagged = [] }).untagged,
        lookup(local.trunk_vlans, vlan_id, { untagged = [] }).untagged
      )
    }
  }
}

resource "routeros_interface_vlan" "list" {
  for_each = local.vlans

  interface = routeros_interface_bridge.bridge.name
  name      = "vlan-${each.key}"
  vlan_id   = each.key
  comment   = format(local.comment_format, "")
}

resource "routeros_interface_bridge_vlan" "list" {
  for_each = local.vlans

  bridge   = routeros_interface_bridge.bridge.name
  vlan_ids = [each.key]
  tagged   = concat([routeros_interface_bridge.bridge.name], each.value.tagged)
  untagged = each.value.untagged
  comment  = format(local.comment_format, "")
}
