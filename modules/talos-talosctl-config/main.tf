data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_config.cluster_name
  client_configuration = var.cluster_config.client_configuration
  endpoints            = [var.cluster_config.vip_ip]
}

resource "local_file" "this" {
  content         = data.talos_client_configuration.this.talos_config
  filename        = var.config_path
  file_permission = "600"
}