locals {
  # Note: In the default Kubernetes configuration, worker nodes are not allowed to
  # modify the taints (see NodeRestriction admission plugin),
  # thus setting taints is only allowed on node creation.

  # This transforms from nodeAnnotations format to kubelet.extraConfig.registerWithTaints format
  # from { elasticsearch = "true:NoSchedule" }
  # to { effect: "NoSchedule", key: "elasticsearch", value: "true" }
  #
  # Refs:
  # https://www.talos.dev/v1.10/reference/configuration/v1alpha1/config/#Config.machine
  # https://github.com/siderolabs/talos/discussions/9895#discussioncomment-11506439
  kubelet_register_with_taints = [
    for key, value in var.node_taints :
    {
      key   = key
      effect = split(":", value)[1]
      value = split(":", value)[0]
    }
  ]
}

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
          extraConfig = {
            registerWithTaints: local.kubelet_register_with_taints
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
        machine: {
          nodeLabels: merge(
            # metallb honors node-kubernetes-io-exclude-from-external-load-balancers
            # we want to delete this if scheduling is enabled on controlplanes
            # https://metallb.universe.tf/troubleshooting/#metallb-is-not-advertising-my-service-from-my-control-plane-nodes-or-from-my-single-node-cluster
            var.cluster_config.allow_scheduling_on_control_planes == false ? null : {
              "node.kubernetes.io/exclude-from-external-load-balancers" : {
                "$patch": "delete"
              }
            }
          )
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
