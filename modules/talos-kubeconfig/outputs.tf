output "config" {
  value     = talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive = true
}
