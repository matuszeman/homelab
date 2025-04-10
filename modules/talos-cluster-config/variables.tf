variable "talos_version" {}
variable "cluster_name" {}
variable "network" {}
variable "vip_ip" {}
variable "vip_dns" {}
variable "allow_scheduling_on_control_planes" {
  type = bool
}
# https://www.talos.dev/v1.9/kubernetes-guides/configuration/deploy-metrics-server/
variable "metrics_server_enabled" {
  type = bool
}