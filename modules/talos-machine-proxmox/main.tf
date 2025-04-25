locals {
  cluster_nic_name = coalesce(var.cluster_nic, keys(var.nics)[0])
  talos_image = var.talos_image_versions[var.talos_version]
  cluster_nic = local.nics[local.cluster_nic_name]
  vm_mac_ipv4_map = zipmap(proxmox_virtual_environment_vm.this.mac_addresses, proxmox_virtual_environment_vm.this.ipv4_addresses)
  node_ip = local.vm_mac_ipv4_map[upper(local.cluster_nic.mac)][0]
  nics = module.cloudinit-network.nics
  memory_mbs = var.memory_gb * 1024
}

module "talos-machine-config" {
  source = "../talos-machine-config"
  machine_type = var.talos_machine_type
  cluster_config = var.cluster_config
  hostname = var.name
  nics = module.cloudinit-network.nics
  cluster_nic_name = local.cluster_nic_name
  install_disk = "/dev/vda"
  install_image = local.talos_image.installer
  node_labels = var.node_labels
  node_annotations = var.node_annotations
  node_taints = var.node_taints
  bootstrap = var.bootstrap
}

# https://github.com/ionfury/homelab-modules/blob/main/modules/talos-cluster/apply.tf#L6
resource "talos_machine_configuration_apply" "this" {
  client_configuration        = var.cluster_config.client_configuration
  machine_configuration_input = module.talos-machine-config.machine_configuration
  node                        = local.node_ip
}

resource "talos_machine_bootstrap" "this" {
  count = var.bootstrap ? 1 : 0
  depends_on = [
    talos_machine_configuration_apply.this
  ]
  node                 = local.node_ip
  client_configuration = var.cluster_config.client_configuration
}

# data "talos_cluster_health" "this" {
#   count = var.bootstrap ? 1 : 0
#   depends_on = [talos_machine_bootstrap.this]
#   client_configuration = var.cluster_config.client_configuration
#   control_plane_nodes = [local.node_ip]
#   endpoints = [var.cluster_config.cluster_endpoint]
# }

# cloud-init talos impl does not support "set-name" on ethernet interface
# but cloudinit is used for network configuration anyway
# talos machine config is used for talos specific things only.
module "cloudinit-network" {
  source = "../vm-cloudinit-network-proxmox"

  name = var.name
  pve_datastore = var.pve_cloudinit_storage
  pve_node = var.pve_node
  nics = var.nics
}

resource "proxmox_virtual_environment_vm" "this" {
  #depends_on = [module.cloudinit-network]

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

  dynamic "network_device" {
    for_each = local.nics
    content {
      mac_address = network_device.value.mac
    }
  }

  boot_order = ["virtio0", "ide3"]
  disk {
    # /dev/vda
    interface = "virtio0"
    size = var.root_volume_size_gb
    discard = "on"
    iothread = true
  }

  cdrom {
    file_id     = local.talos_image.iso_file_id
  }

  operating_system {
    type = "l26"
  }

  initialization {
    network_data_file_id = module.cloudinit-network.file_id
  }
}