resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "control-plane" {
  cluster_name     = var.talos.cluster_name
  cluster_endpoint = var.talos.cluster_endpoint
  machine_type     = "control-plane"
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
  depends_on = [proxmox_virtual_environment_vm.this]
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.control-plane.machine_configuration
  for_each                    = var.vm_params
  node                        = each.value.role == "control-plane" ? each.value.ip_address : null
  config_patches = [
    yamlencode({
      machine = {
        network = {
          hostname = each.key
        }
      }
    })
  ]
}

resource "talos_machine_configuration_apply" "worker" {
  depends_on = [proxmox_virtual_environment_vm.this]
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  for_each                    = var.vm_params
  node                        = each.value.role == "worker" ? each.value.ip_address : null
  config_patches = [
    yamlencode({
      machine = {
        network = {
          hostname = each.key
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
