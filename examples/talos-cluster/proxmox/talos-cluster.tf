locals {
  talos_version = "v1.9.0"
}

module "talos-image-versions" {
  for_each = toset([
    "v1.9.0",
    "v1.9.5"
  ])

  source = "../../../modules/talos-image-proxmox"
  pve_node = local.pve_node
  pve_storage = local.pve_iso_storage
  talos_version = each.key
}

module "talos-config" {
  source = "../../../modules/talos-cluster-config"
  cluster_name = "talos"
  network = local.networking_state.networks.mgmt
  vip_ip = local.networking_state.networks.mgmt.static_ips.talos-cluster.address
  vip_dns = "talos-cluster.${local.networking_state.networks.mgmt.domain}"
  talos_version = "v1.9.0"
}

module "talos-kubeconfig" {
  source = "../../../modules/talos-kubeconfig"
  cluster_config = module.talos-config
  config_path = "${path.module}/.kube/config"
}

module "talos-ctl-config" {
  source = "../../../modules/talos-talosctl-config"
  cluster_config = module.talos-config
  config_path = "${path.module}/.talos/config"
}

# https://www.talos.dev/v1.9/introduction/system-requirements/
module "talos-1" {
  source = "../../../modules/talos-machine-proxmox"
  name = "talos-1"
  pve_node = local.pve_node
  pve_cloudinit_storage = local.pve_iso_storage

  cluster_config = module.talos-config
  bootstrap = true
  talos_version = local.talos_version
  talos_machine_type = "controlplane"
  talos_image_versions = module.talos-image-versions

  memory_gb = 2
  vcpu = 2
  root_volume_size_gb = 10

  vip_nic = "mgmt"
  nics = {
    mgmt = {
      network = local.networking_state.networks.mgmt
      mac = local.networking_state.networks.mgmt.static_ips.talos-1.mac
    }
  }
}

module "talos-2" {
  source = "../../../modules/talos-machine-proxmox"
  name = "talos-2"
  pve_node = local.pve_node
  pve_cloudinit_storage = local.pve_iso_storage

  cluster_config = module.talos-config
  talos_version = local.talos_version
  talos_machine_type = "worker"
  talos_image_versions = module.talos-image-versions

  memory_gb = 2
  vcpu = 1
  root_volume_size_gb = 10

  vip_nic = "mgmt"
  nics = {
    mgmt = {
      network = local.networking_state.networks.mgmt
      mac = local.networking_state.networks.mgmt.static_ips.talos-2.mac
    }
  }
}
