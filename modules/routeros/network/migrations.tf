moved {
  from = routeros_ip_dhcp_server_lease.statics
  to   = module.dhcp-server[0].routeros_ip_dhcp_server_lease.statics
}

moved {
  from = routeros_ip_dhcp_server_network.this
  to   = module.dhcp-server[0].routeros_ip_dhcp_server_network.this
}

moved {
  from = routeros_ip_pool.this
  to   = module.dhcp-server[0].routeros_ip_pool.this
}
moved {
  from = routeros_ip_dhcp_server.this
  to   = module.dhcp-server[0].routeros_ip_dhcp_server.this
}
