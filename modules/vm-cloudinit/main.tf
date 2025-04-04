locals {
  hashed_passwd = bcrypt(var.user.password)
  hostname = var.hostname
  user_data = yamlencode({
    #cloud-config
    hostname : local.hostname
    write_files: var.write_files
    users : [
      {
        name : var.user.name
        shell : "/bin/bash"
        sudo : "ALL=(ALL) NOPASSWD:ALL"
        lock_passwd : false
        hashed_passwd : local.hashed_passwd
        ssh-authorized-keys : [var.user.ssh_authorized_key]
      }
    ]
    growpart : {
      mode : "auto"
      devices : ["/"]
    }
#    packages: [
#      "qemu-guest-agent"
#    ]
    runcmd : [
      var.runcmd
    ]
  })
  # match / set-name: https://netplan.readthedocs.io/en/latest/netplan-yaml/#properties-for-physical-device-types
  # https://unix.stackexchange.com/questions/464537/rename-network-interface-ubuntu-on-instance-boot-cloud-init
  # match by name didn't work - had to use macaddress
  nics_config = {
    for i, config in var.nics : "eth${i}" => config.static_ip == null ? yamlencode({
      match: {
        macaddress: config.mac
      }
      set-name: config.name
      dhcp4: true
      dhcp4-overrides: {
        hostname: local.hostname
        route-metric: 100 + i
      }
    }) : yamlencode({
      match: {
        macaddress: config.mac
      }
      set-name: config.name
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
          metric : 100 + i
        }
      ]
    })
  }
  # https://netplan.io/reference#dhcp-overrides
  network_config = yamlencode({
    version: 2
    ethernets: { for i, yaml in local.nics_config: i => yamldecode(yaml) }
  })
}