resource "talos_cluster_kubeconfig" "this" {
  client_configuration = var.cluster_config.client_configuration
  node                 = var.cluster_config.vip_ip
}

resource "local_file" "version_config" {
  content         = talos_cluster_kubeconfig.this.kubeconfig_raw
  filename        = var.config_path
  file_permission = "600"
}