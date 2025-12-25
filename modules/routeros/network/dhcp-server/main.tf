module "pool" {
  source = "../../../network-address-pool-output"
  pool = var.address_pool
}

resource "routeros_ip_pool" "this" {
  comment = format(local.comment_format, "")
  name    = "${var.network.name}-dhcp"
  ranges  = ["${module.pool.range.start}-${module.pool.range.end}"]
}

resource "routeros_ip_dhcp_server" "this" {
  address_pool = routeros_ip_pool.this.name
    disabled     = var.disabled
  interface    = var.interface
  name         = var.network.name
  comment      = format(local.comment_format, "")
  lease_time   = var.lease_time
}

resource "routeros_ip_dhcp_server_network" "this" {
  comment    = format(local.comment_format, "")
  address    = var.network.cidr
  gateway    = var.network.gateway
  dns_server = var.network.nameservers
  # https://en.wikipedia.org/wiki/Search_domain
  domain = var.network.domain
}
