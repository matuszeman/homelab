output "talosconfig" {
  value     = data.talos_client_configuration.this.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive = true
}

output "talos_cluster_name" {
  value = var.talos.cluster_name
}

output "talos_cluster_version" {
  value = var.talos.version
}
