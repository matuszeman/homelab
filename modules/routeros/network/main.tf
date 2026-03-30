resource "routeros_ip_address" "this" {
  comment   = format(local.comment_format, "")
  disabled = var.disabled
  address   = "${var.network.gateway}/${split("/", var.network.cidr)[1]}"
  interface = var.interface
}

module "dhcp-server" {
  source = "./dhcp-server"
  count = var.dhcp_server != null ? 1 : 0

  ctx = var.ctx
  disabled = var.disabled
  interface = var.interface
  network = var.network
  address = var.network.dhcp_server
  address_pool = var.network.address_pools[var.dhcp_server.adress_pool_name]
  lease_time = var.dhcp_server.lease_time
  ntp_server_ips = var.dhcp_server.ntp_server_ips
}
