locals {
  #cluster_nic_name = coalesce(var.cluster_nic, keys(var.nics)[0])
  #talos_image = var.talos_image_versions[var.talos_version]
  #cluster_nic = local.nics[local.cluster_nic_name]
  vm_mac_addresses = [
    for mac in proxmox_virtual_environment_vm.this.mac_addresses : lower(mac)
  ]
  vm_mac_ipv4_map = zipmap(local.vm_mac_addresses, proxmox_virtual_environment_vm.this.ipv4_addresses)
  vm_mac_ipv6_map = zipmap(local.vm_mac_addresses, proxmox_virtual_environment_vm.this.ipv6_addresses)
  vm_mac_interface_map = zipmap(local.vm_mac_addresses, proxmox_virtual_environment_vm.this.network_interface_names)
  cloudinit_nics = module.cloudinit-network.nics
  memory_mbs = var.memory_gb * 1024
  nics = {
    for nic_key, nic in local.cloudinit_nics : nic_key => merge(
      nic,
      {
        ipv4_address = lookup(local.vm_mac_ipv4_map, nic.mac, [null])[0],
        ipv6_address = lookup(local.vm_mac_ipv6_map, nic.mac, [null])[0],
        interface_name = lookup(local.vm_mac_interface_map, nic.mac, null),
      }
    )
  }
}

# cloud-init talos impl does not support "set-name" on ethernet interface
# but cloudinit is used for network configuration anyway
# talos machine config is used for talos specific things only.
module "cloudinit-network" {
  source = "../../vm-cloudinit-network-proxmox"

  name = var.name
  pve_datastore = var.pve_cloudinit_storage
  pve_node = var.pve_node
  nics = var.nics
}

# talos - https://blog.stonegarden.dev/articles/2024/08/talos-proxmox-tofu/#talos-bootstrap
resource "proxmox_virtual_environment_vm" "this" {
  vm_id =  var.vm_id

  name      = var.name
  node_name = var.pve_node
  # use lowercase, proxmox converts them to lowercase
  tags      = ["tf", "env.${var.ctx.env}"]

  scsi_hardware = var.scsi_hardware
  machine = var.machine

  cpu {
    cores = var.vcpu
    #type  = "x86-64-v2-AES"
    type  = "host"
  }

  memory {
    # TODO dedicated / floating
    dedicated = local.memory_mbs
    floating  = local.memory_mbs
  }

  agent {
    #enabled = false
    enabled = true
  }

  dynamic "network_device" {
    for_each = local.cloudinit_nics
    content {
      mac_address = network_device.value.mac
      vlan_id = try(var.nics[network_device.key].vlan_id, null)
    }
  }

  boot_order = ["virtio0", "ide0"]
  disk {
    # /dev/vda
    interface = "virtio0"
    size = var.root_volume_size_gb
    discard = "on"
    iothread = true
    cache        = "writethrough"
    file_format  = "raw"
    #file_id = var.pve_iso_file_id
  }

  dynamic "disk" {
    for_each = var.data_volumes
    content {
      interface   = disk.value.interface
      size        = disk.value.size_gb
      discard     = "on"
      iothread    = true
      cache       = "writethrough"
      file_format = "raw"
      ssd = true
    }
  }

  # https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm#cdrom-1
  # Note that q35 machine type only supports ide0 and ide2 of IDE interfaces.
  cdrom {
    interface = "ide0"
    file_id     = var.pve_iso_file_id
  }

  operating_system {
    type = "l26"
  }

  initialization {
    network_data_file_id = module.cloudinit-network.file_id
  }
}
