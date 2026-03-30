resource "routeros_ip_firewall_addr_list" "lists" {
  for_each = var.network.address_pools

  address = each.value.cidr != null ? each.value.cidr : "${each.value.range.start}-${each.value.range.end}"
  comment = "network=${var.network.name} pool=${each.key}"
  list    = "${var.network.name}-${each.key}"
}
