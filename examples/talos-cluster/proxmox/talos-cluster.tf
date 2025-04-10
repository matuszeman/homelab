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

module "talos-cluster-config" {
  source = "../../../modules/talos-cluster-config"
  cluster_name = "talos"
  network = local.networks.default
  vip_ip = local.networks.default.static_ips.talos-cluster.address
  vip_dns = "talos-cluster.${local.networking_state.networks.default.domain}"
  talos_version = "v1.9.0"
  allow_scheduling_on_control_planes = true
  metrics_server_enabled = true
}

module "talos-kubeconfig" {
  source = "../../../modules/talos-kubeconfig"
  cluster_config = module.talos-cluster-config
  config_path = "${path.module}/.kube/config"
}

module "talos-ctl-config" {
  source = "../../../modules/talos-talosctl-config"
  cluster_config = module.talos-cluster-config
  config_path = "${path.module}/.talos/config"
}

# https://www.talos.dev/v1.9/introduction/system-requirements/
module "talos-1" {
  source = "../../../modules/talos-machine-proxmox"
  name = "talos-1"
  pve_node = local.pve_node
  pve_cloudinit_storage = local.pve_iso_storage

  cluster_config = module.talos-config

  # !!!! Use on first controlplane node only !!!!
  bootstrap = true

  talos_version = local.talos_version
  talos_machine_type = "controlplane"
  talos_image_versions = module.talos-image-versions

  memory_gb = 2
  vcpu = 2
  root_volume_size_gb = 10

  vip_nic = "default"
  nics = {
    default = {
      network = local.networks.default
      mac = local.networks.default.static_ips.talos-1.mac
    }
  }
}

module "talos-2" {
  source = "../../../modules/talos-machine-proxmox"
  name = "talos-2"
  pve_node = local.pve_node
  pve_cloudinit_storage = local.pve_iso_storage

  cluster_config = module.talos-cluster-config
  talos_version = local.talos_version
  talos_machine_type = "worker"
  talos_image_versions = module.talos-image-versions

  memory_gb = 2
  vcpu = 1
  root_volume_size_gb = 10

  vip_nic = "default"
  nics = {
    default = {
      network = local.networks.default
      mac = local.networks.default.static_ips.talos-2.mac
    }
  }
}
