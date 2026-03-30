data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_config.cluster_name
  client_configuration = var.cluster_config.client_configuration
  # TODO use node IPs/DNS names, use vip_dns only for kubectl config
  endpoints            = [var.cluster_config.vip_dns]
}

resource "local_file" "this" {
  content         = data.talos_client_configuration.this.talos_config
  filename        = var.config_path
  file_permission = "600"
}
