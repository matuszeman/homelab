output "address_pools" {
  value = {
    for name, res in var.network.address_pools : name => {
      firewall_address_list = routeros_ip_firewall_addr_list.lists[name].list
    }
  }
}
