module "pool" {
  source = "../../network-address-pool-output"
  pool = var.address_pool
}

resource "routeros_ip_pool" "this" {
  comment = "TF"
  name    = "${var.network.name}-dhcp"
  ranges  = ["${module.pool.range.start}-${module.pool.range.end}"]
}

resource "routeros_ip_dhcp_server" "this" {
  address_pool = routeros_ip_pool.this.name
  interface    = var.interface
  name         = var.network.name
  comment      = "TF"
}

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

resource "routeros_ip_dhcp_server_network" "this" {
  comment    = "TF - ${var.network.name}"
  address    = var.network.cidr
  gateway    = var.network.gateway
  dns_server = var.network.nameservers
  # https://en.wikipedia.org/wiki/Search_domain
  domain = var.network.domain
}