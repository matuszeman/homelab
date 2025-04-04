resource "routeros_ip_dhcp_client" "wan" {
  interface = var.wan.interface
  comment   = "TF"
  # Disabled - we want to use static IP
  #disabled = false
  #add_default_route = "yes"
  #use_peer_dns = true
  #use_peer_ntp = true
}

# resource "routeros_ip_address" "wan" {
#   comment = "WAN"
#   disabled = false
#   address   = "192.168.100.2/24"
#   interface = local.interfaces.ether1
#   #network   = "192.168.88.0"
# }
