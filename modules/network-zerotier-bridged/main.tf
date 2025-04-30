locals {
  network_address_pool = var.network.address_pools[var.address_pool]
}

module "assignment-pool" {
  source = "../network-address-pool-output"
  pool = local.network_address_pool
}

resource "zerotier_network" "this" {
  name = var.network.name
  description = "tf - bridged"

  dns {
    domain = var.network.domain
    servers = var.network.nameservers
  }

  # even when on bridged network is DHCP server
  # it might not work with all zerotier clients
  # it's better to assign extra pool outside of dhcp network range for zerotier
  # https://forum.mikrotik.com/viewtopic.php?t=183424
  assignment_pool {
    start = module.assignment-pool.range.start
    end   = module.assignment-pool.range.end
  }
  assign_ipv4 {
    zerotier = var.network.dhcp_server != null
  }

  route {
    target = var.network.cidr
    via = var.network.gateway
  }
}
