output "cluster_name" {
  value = var.cluster_name
}

output "cluster_endpoint" {
  value = "https://${var.vip_dns}:6443"
}

output "machine_secrets" {
  value = talos_machine_secrets.this.machine_secrets
}

output "client_configuration" {
  value = talos_machine_secrets.this.client_configuration
}

output "network" {
  value = var.network
}

output "vip_ip" {
  value = var.vip_ip
}

output "vip_dns" {
  value = var.vip_dns
}