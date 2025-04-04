resource "routeros_ip_address" "this" {
  comment = "TF"
  address   = "${var.default_gateway}/${split("/", var.network)[1]}"
  interface = var.interface
}

resource "routeros_ip_pool" "this" {
  comment = "TF"
  name   = "${var.name}-dhcp"
  ranges = ["${var.dhcp_range.start}-${var.dhcp_range.end}"]
}

resource "routeros_ip_dhcp_server" "this" {
  address_pool = routeros_ip_pool.this.name
  interface    = var.interface
  name         = var.name
  comment = "TF"
}

resource "routeros_ip_dhcp_server_lease" "statics" {
  for_each = var.static_ip_allocations
  comment = "TF - ${each.key}"
  server = routeros_ip_dhcp_server.this.name
  address     = each.value.address
  mac_address = each.value.mac
}

resource "routeros_ip_dhcp_server_network" "this" {
  comment = "TF"
  address    = var.network
  gateway    = var.default_gateway
  dns_server = var.nameservers
  # https://en.wikipedia.org/wiki/Search_domain
  # TODO Is this what we want? Have FQD here?
  domain = var.domain
}