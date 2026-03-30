variable "talos_init_version" {}
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
# https://www.talos.dev/v1.9/reference/configuration/v1alpha1/config/#Config.machine.registries.config.-
# Update of registry configs needs node restarts
variable "registries_config" {
  default = {}
}