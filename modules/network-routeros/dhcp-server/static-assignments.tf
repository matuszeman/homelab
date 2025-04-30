locals {
  static_ips = {
    for name, spec in var.network.static_ips : name => spec if spec.mac != null
  }
}
resource "routeros_ip_dhcp_server_lease" "statics" {
  for_each    = local.static_ips

  comment     = "TF - ${each.key}"
  server      = routeros_ip_dhcp_server.this.name
  address     = each.value.address
  mac_address = each.value.mac
}
