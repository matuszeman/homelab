resource "routeros_ip_address" "this" {
  comment   = "TF - ${var.network.name}"
  address   = "${var.network.gateway}/${split("/", var.network.cidr)[1]}"
  interface = var.interface
}

module "dhcp-server" {
  source = "./dhcp-server"
  count = var.network.dhcp_server == var.network.gateway ? 1 : 0

  interface = var.interface
  network = var.network
  address = var.network.dhcp_server
  address_pool = var.network.address_pools[var.dhcp_address_pool]
}