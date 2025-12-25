output "name" {
  value = routeros_interface_bridge.bridge.name
}

output "vlans" {
  value = {
    for key, int in routeros_interface_vlan.list : key => {
      interface = int.name
      vlan_id = int.vlan_id
    }
  }
}
