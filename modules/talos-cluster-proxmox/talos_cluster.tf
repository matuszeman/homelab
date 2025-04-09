resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "control-plane" {
  cluster_name     = var.talos.cluster_name
  cluster_endpoint = var.talos.cluster_endpoint
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.talos.cluster_name
  cluster_endpoint = var.talos.cluster_endpoint
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
  cluster_name         = var.talos.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [for k, v in var.vm_params : v.ip_address]
}

resource "talos_machine_configuration_apply" "control-plane" {
  depends_on                  = [proxmox_virtual_environment_vm.this]
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.control-plane.machine_configuration
  for_each                    = { for k, v in var.vm_params : k => v if v.role == "control-plane" }
  node                        = each.value.ip_address
  config_patches = [
    yamlencode({
      machine = {
        network = {
          hostname = each.key
        }
        kubelet = {
          extraArgs = {
            rotate-server-certificates = var.talos_config.kubelet_rotate_certificates
          }
        }
        cluster = {
          allow_scheduling_on_control_planes = var.talos_config.allow_scheduling_on_control_planes
          extraManifests =  var.talos_config.enable_metric_server ? [
            "https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/main/deploy/standalone-install.yaml",
            "https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
          ] : null
        }
      }
    })
  ]
}

resource "talos_machine_configuration_apply" "worker" {
  depends_on                  = [proxmox_virtual_environment_vm.this]
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  for_each                    = { for k, v in var.vm_params : k => v if v.role == "worker" }
  node                        = each.value.ip_address
  config_patches = [
    yamlencode({
      machine = {
        network = {
          hostname = each.key
        }
        kubelet = {
          extraArgs = {
            rotate-server-certificates = var.talos_config.kubelet_rotate_certificates
          }
        }
        cluster = {
          allow_scheduling_on_control_planes = var.talos_config.allow_scheduling_on_control_planes
          extraManifests =  var.talos_config.enable_metric_server ? [
            "https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/main/deploy/standalone-install.yaml",
            "https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
          ] : null
        }
      }
    })
  ]
}

resource "talos_machine_bootstrap" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for k, v in var.vm_params : v.ip_address if v.role == "control-plane"][0]
}

resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for k, v in var.vm_params : v.ip_address if v.role == "control-plane"][0]
}
