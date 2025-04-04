resource "routeros_ip_address" "this" {
  comment   = "TF"
  address   = "${var.network.gateway}/${split("/", var.network.cidr)[1]}"
  interface = var.interface
}

resource "routeros_ip_pool" "this" {
  comment = "TF"
  name    = "${var.network.name}-dhcp"
  ranges  = ["${var.network.dhcp.range.start}-${var.network.dhcp.range.end}"]
}

resource "routeros_ip_dhcp_server" "this" {
  address_pool = routeros_ip_pool.this.name
  interface    = var.interface
  name         = var.network.name
  comment      = "TF"
}

resource "routeros_ip_dhcp_server_lease" "statics" {
  for_each    = var.network.static_ips

  comment     = "TF - ${each.key}"
  server      = routeros_ip_dhcp_server.this.name
  address     = each.value.address
  mac_address = each.value.mac
}

resource "routeros_ip_dhcp_server_network" "this" {
  comment    = "TF"
  address    = var.network.cidr
  gateway    = var.network.gateway
  dns_server = var.network.nameservers
  # https://en.wikipedia.org/wiki/Search_domain
  # TODO Is this what we want? Have FQD here?
  domain = var.network.domain
}