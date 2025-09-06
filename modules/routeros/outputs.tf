output "name" {
  value = var.name
}

output "bridge_name" {
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

# output "networks" {
#   value = {
#     for id, net in var.networks : id => {
#       interface = try(routeros_interface_vlan.list["${net.vlan}"].name, routeros_interface_bridge.bridge.name)
#     }
#   }
# }
