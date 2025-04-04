# https://mikrotik.com/product/hap_ax3

# Default config imports
import {
  id = "*9"
  to = module.routeros.routeros_interface_bridge.bridge
}
import {
  id = "*0"
  to = module.routeros.routeros_interface_bridge_port.ports["ether2"]
}
import {
  id = "*1"
  to = module.routeros.routeros_interface_bridge_port.ports["ether3"]
}
import {
  id = "*2"
  to = module.routeros.routeros_interface_bridge_port.ports["ether4"]
}
import {
  id = "*3"
  to = module.routeros.routeros_interface_bridge_port.ports["ether5"]
}
import {
  id = "*4"
  to = module.routeros.routeros_interface_bridge_port.ports["wifi1"]
}
import {
  id = "*5"
  to = module.routeros.routeros_interface_bridge_port.ports["wifi2"]
}
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_list#import
# ;;; defconf
# *2000010   WAN
# ;;; defconf
# *2000011   LAN
import {
  id = "*2000011"
  to = module.routeros.routeros_interface_list.lan
}
import {
  id = "*2000010"
  to = module.routeros.routeros_interface_list.wan
}

import {
  id = "*1"
  to = module.routeros.module.networks["mgmt"].routeros_ip_address.this
}
import {
  id = "*1"
  to = module.routeros.module.networks["mgmt"].routeros_ip_pool.this
}
import {
  id = "*1"
  to = module.routeros.module.networks["mgmt"].routeros_ip_dhcp_server.this
}
import {
  id = "*1"
  to = module.routeros.module.networks["mgmt"].routeros_ip_dhcp_server_network.this
}

import {
  id = "*1"
  to = module.routeros.routeros_ip_dhcp_client.wan
}