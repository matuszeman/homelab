module "machine-config" {
  source = "../machine-config"
  machine_type = var.talos_machine_type
  cluster_config = var.cluster_config
  kubernetes_version = var.kubernetes_version
  #hostname = var.hostname
  nics = var.nics
  install_disk = var.install_disk
  install_image = var.talos_image.installer
  node_labels = var.node_labels
  node_annotations = var.node_annotations
  node_taints = var.node_taints
  bootstrap = var.bootstrap
  extra_mounts = var.extra_mounts
  extra_config_patches = var.extra_config_patches
}

#https://github.com/ionfury/homelab-modules/blob/main/modules/talos-cluster/apply.tf#L6
resource "talos_machine_configuration_apply" "this" {
  client_configuration        = var.cluster_config.client_configuration
  machine_configuration_input = module.machine-config.machine_configuration
  node                        = var.ip

  # on_destroy = {
  #   # https://registry.terraform.io/providers/siderolabs/talos/latest/docs/resources/machine_configuration_apply#nested-schema-for-on_destroy
  #   #reset = true
  # }
}

resource "talos_machine_bootstrap" "this" {
  count = var.bootstrap ? 1 : 0
  depends_on = [
    talos_machine_configuration_apply.this
  ]
  node                 = var.ip
  client_configuration = var.cluster_config.client_configuration
}

# data "talos_cluster_health" "this" {
#   count = var.bootstrap ? 1 : 0
#   depends_on = [talos_machine_bootstrap.this]
#   client_configuration = var.cluster_config.client_configuration
#   control_plane_nodes = [local.node_ip]
#   endpoints = [var.cluster_config.cluster_endpoint]
# }
