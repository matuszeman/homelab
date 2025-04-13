locals {
  networks = {
    for name, spec in var.networks : name => spec if can(spec.address_pools.metallb)
  }
}

module "this" {
  source = "../../modules/argocd-app"
  argocd        = var.argocd

  repo_url      = "https://metallb.github.io/metallb"
  chart         = "metallb"
  chart_version = "0.14.9"
  namespace     = var.namespace
  release       = "metallb"

  values_object = {
#     speaker : {
#       nodeSelector : {
#         "network.node.homelab/home" : "true"
#       }
#     }
  }
}


resource "kubectl_manifest" "ip_address_pools" {
  for_each = local.networks
  depends_on = [module.this]
  yaml_body = yamlencode({
    "apiVersion" = "metallb.io/v1beta1"
    "kind" = "IPAddressPool"
    "metadata" = {
      "name" = each.value.name
      "namespace" = var.namespace
    }
    "spec" = {
      "addresses" = [
        each.value.address_pools.metallb.cidr
      ]
    }
  })
}

resource "kubectl_manifest" "l2_advertisements" {
  for_each = local.networks
  depends_on = [module.this]
  yaml_body = yamlencode({
    "apiVersion" = "metallb.io/v1beta1"
    "kind" = "L2Advertisement"
    "metadata" = {
      "name" = each.value.name
      "namespace" = var.namespace
    }
    "spec" = {
      "ipAddressPools" = [
        each.value.name,
      ]
#       "interfaces" = [
#         each.value.name
#       ]
#       "nodeSelectors" = [
#         {
#           "matchLabels" = {
#             "network.node.homelab/${each.value.name}" = "true"
#           }
#         },
#       ]
    }
  })
}