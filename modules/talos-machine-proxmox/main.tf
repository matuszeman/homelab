module "cloudinit-network" {
  source = "../vm-cloudinit-network-proxmox"

  name = var.name
  pve_datastore = var.pve_cloudinit_storage
  pve_node = var.pve_node
  nics = var.nics
}

module "talos-controlplane-config" {
  source = "../talos-machine-config"
  machine_type = var.talos_machine_type
  cluster_config = var.cluster_config
  vip_nic = local.vip_nic
  install_disk = "/dev/vda"
  install_image = local.talos_image.installer
}

locals {
  talos_image = var.talos_image_versions[var.talos_version]
  vip_nic = module.cloudinit-network.nics[var.vip_nic]
  vm_mac_ipv4_map = zipmap(proxmox_virtual_environment_vm.this.mac_addresses, proxmox_virtual_environment_vm.this.ipv4_addresses)
  node_ip = local.vm_mac_ipv4_map[upper(local.vip_nic.mac)][0]

  memory_mbs = var.memory_gb * 1024
}

# https://github.com/ionfury/homelab-modules/blob/main/modules/talos-cluster/apply.tf#L6
resource "talos_machine_configuration_apply" "this" {
  client_configuration        = var.cluster_config.client_configuration
  machine_configuration_input = module.talos-controlplane-config.machine_configuration
  node                        = local.node_ip

  # https://www.talos.dev/v1.9/talos-guides/configuration/editing-machine-configuration/
  #apply_mode = "auto"
  # https://registry.terraform.io/providers/siderolabs/talos/latest/docs/resources/machine_configuration_apply
#   on_destroy = {
#     graceful = true
#     reboot   = true
#     reset    = true
#   }
}

resource "talos_machine_bootstrap" "this" {
  count = var.bootstrap ? 1 : 0
  depends_on = [
    talos_machine_configuration_apply.this
  ]
  node                 = local.node_ip
  client_configuration = var.cluster_config.client_configuration
}

output "node_ip" {
  value = {
    node_ip = local.node_ip
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  depends_on = [module.cloudinit-network]

  name      = var.name
  node_name = var.pve_node
  # use lowercase, proxmox converts them to lowercase
  tags      = ["tf", "talos"]

  cpu {
    cores = var.vcpu
    type  = "x86-64-v2-AES"
  }

  memory {
    # TODO dedicated / floating
    dedicated = local.memory_mbs
    floating  = local.memory_mbs
  }

  agent {
    enabled = true
  }
  #stop_on_destroy = true

  dynamic "network_device" {
    for_each = var.nics
    content {
      mac_address = module.cloudinit-network.nics[network_device.key].mac
    }
  }

  boot_order = ["virtio0", "ide3"]
  disk {
    # /dev/vda
    interface = "virtio0"
    size = var.root_volume_size_gb
    #ssd = true
    discard = "on"
    iothread = true
  }

  cdrom {
    file_id     = local.talos_image.iso_file_id
    #interface   = "scsi0"
  }

  operating_system {
    type = "l26"
  }

  initialization {
#     user_account {
#       keys = [var.cloudinit.user.ssh_authorized_key]
#       #username = var.user.name
#       #password = var.user.password
#     }
    network_data_file_id = module.cloudinit-network.file_id
  }
  # required for console to work?
  #serial_device {}
}