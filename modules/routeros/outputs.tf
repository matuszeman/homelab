output "networks" {
  value = {
    for id, net in var.networks : id => {
      interface = try(routeros_interface_vlan.list["${net.vlan}"].name, routeros_interface_bridge.bridge.name)
    }
  }
}
