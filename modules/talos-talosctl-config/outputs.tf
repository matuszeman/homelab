output "talos-config" {
  value     = data.talos_client_configuration.this.talos_config
  sensitive = true
}
