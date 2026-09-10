locals {
  network_address_pool = var.network.address_pools[var.assignment_address_pool_name]
}

module "assignment-pool" {
  source = "../../network-address-pool-output"
  pool = local.network_address_pool
}

resource "zerotier_network" "this" {
  name = var.network.name
  description = "tf: bridged"
  private = var.private

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

  # LAN network
  route {
    target = var.network.cidr
  }

  # For client to use this route they must enable "Route all traffic through ZeroTier"
  dynamic "route" {
    for_each = var.network.gateway != null ? [1] : []
    content {
      target = "0.0.0.0/0"
      via    = var.network.gateway
    }
  }
}
