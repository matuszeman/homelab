# Generate random MACs for nics which does not specify any
resource "macaddress" "macs" {
  for_each = {
    for name, config in var.nics : name => config if config.mac == null
  }
}

locals {
  nics = {
    for name, config in var.nics : name =>
      config.mac != null ? config : merge(config, { mac: macaddress.macs[name].address })
  }

  hostname = var.hostname
  # match / set-name: https://netplan.readthedocs.io/en/latest/netplan-yaml/#properties-for-physical-device-types
  # https://unix.stackexchange.com/questions/464537/rename-network-interface-ubuntu-on-instance-boot-cloud-init
  # match by name didn't work - had to use macaddress
  nics_config = {
    for name, config in local.nics : name => config.static_ip == null ? yamlencode({
      match: {
        macaddress: config.mac
      }
      set-name: name
      dhcp4: true
      dhcp4-overrides: {
        hostname: local.hostname
        route-metric: config.route_metric
      }
    }) : yamlencode({
      match: {
        macaddress: config.mac
      }
      set-name: name
      addresses: [
        "${config.static_ip}/${split("/", config.network.cidr)[1]}"
      ]
      nameservers: {
        addresses : config.network.nameservers
      }
      # gateway4 is deprecated
      # but need to use routes for default gateway anyway, because gateway4 did not set metric,
      # and when multiple cards were attached to VM, with default gateway on both of them,
      # internet connection from pods didn't work.
      routes: [
        {
          to : "0.0.0.0/0"
          via : config.network.gateway
          metric : config.route_metric
        }
      ]
    })
  }
  # https://netplan.io/reference#dhcp-overrides
  network_config = yamlencode({
    version: 2
    ethernets: { for name, yaml in local.nics_config: name => yamldecode(yaml) }
  })
}