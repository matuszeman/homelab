data "talos_machine_configuration" "this" {
  cluster_name     = var.cluster_config.cluster_name
  machine_type     = var.machine_type
  cluster_endpoint = var.cluster_config.cluster_endpoint
  machine_secrets  = var.cluster_config.machine_secrets
  kubernetes_version = var.kubernetes_version

  config_patches = compact([
    # common
    templatefile("${path.module}/common.yaml", {
      nics = var.nics
      machine_type = var.machine_type
      cluster_config = var.cluster_config
      install_disk = var.install_disk
      install_image = var.install_image
      node_labels = var.node_labels
      node_annotations = var.node_annotations
      node_taints = var.node_taints
    }),
    # controlplane
    var.machine_type != "controlplane" ? null : templatefile("${path.module}/controlplane.yaml", {
      cluster_config = var.cluster_config
    }),
    # bootstrap controlplane
    var.bootstrap == false ? null : templatefile("${path.module}/bootstrap.yaml", {}),
    # worker (optional, currently just common, but can be extended)
    var.machine_type == "worker" ? templatefile("${path.module}/worker.yaml", {}) : null
  ])
}
