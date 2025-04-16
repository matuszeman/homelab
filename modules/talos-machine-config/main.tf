data "talos_machine_configuration" "this" {
  cluster_name     = var.cluster_config.cluster_name
  machine_type     = var.machine_type
  cluster_endpoint = var.cluster_config.cluster_endpoint
  machine_secrets  = var.cluster_config.machine_secrets

  config_patches = compact([
    # common
    yamlencode({
      machine: {
        network : {
          hostname = var.hostname
          # https://www.talos.dev/v1.9/advanced/advanced-networking/
          interfaces : [
            for name, nic in var.nics :
            merge(
              {
                deviceSelector : {
                  hardwareAddr : nic.mac
                }
              },
              var.machine_type != "controlplane" || var.cluster_nic_name != name ? null : {
                vip : {
                  ip : var.cluster_config.vip_ip
                }
              }
            )
          ]
        }
        install = {
          disk = var.install_disk
          image = var.install_image
        }
        kubelet: {
          extraArgs = {
            rotate-server-certificates = var.cluster_config.metrics_server_enabled
          }
          nodeIP: {
            validSubnets: [
              var.cluster_config.network.cidr
            ]
          }
        }
        nodeLabels: var.node_labels
        nodeAnnotations: var.node_annotations
        nodeTaints: var.node_taints
        registries: {
          config: var.cluster_config.registries_config
        }
      }
    }),
    # controlplane
    var.machine_type != "controlplane" ? null : # control plane only
      yamlencode({
        cluster: {
          allowSchedulingOnControlPlanes: var.cluster_config.allow_scheduling_on_control_planes
        }
      }),
    # bootstrap controlplane
      var.bootstrap == false ? null :
      yamlencode({
        cluster: {
          extraManifests: [
            "https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/main/deploy/standalone-install.yaml",
            "https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
          ]
        }
      })
  ])
}
