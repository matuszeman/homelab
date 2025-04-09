data "talos_machine_configuration" "this" {
  cluster_name     = var.cluster_config.cluster_name
  machine_type     = var.machine_type
  cluster_endpoint = var.cluster_config.cluster_endpoint
  machine_secrets  = var.cluster_config.machine_secrets

  config_patches = compact([
    # common
    yamlencode({
      machine: {
        install = {
          disk = var.install_disk
          image = var.install_image
        }
        kubelet: {
          nodeIP: {
            validSubnets: [
              var.cluster_config.network.cidr
            ]
          }
        }
      }
    }),
    # controlplane
    var.machine_type != "controlplane" ? null : # control plane only
      yamlencode({
        machine: {
          network : {
            interfaces : [
              {
                deviceSelector : {
                  hardwareAddr : var.vip_nic.mac
                }
                vip : {
                  ip : var.cluster_config.vip_ip
                }
              }
            ]
          }
        }
      })
  ])
}
