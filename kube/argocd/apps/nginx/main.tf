locals {
  ingress_class = var.release
}

module "argocd" {
  source = "./../../modules/argocd-app"
  argocd = var.argocd

  # https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx
  chart         = "ingress-nginx"
  chart_version = "4.12.2"
  repo_url      = "https://kubernetes.github.io/ingress-nginx"
  release       = var.release
  namespace     = var.namespace

  skip_crds = true

  values_object_override = var.helm_values_override
  values_object = merge({
    fullnameOverride : var.release
    nameOverride : var.release
    controller : {
      ingressClass: local.ingress_class
      ingressClassResource: {
        name: local.ingress_class
        # this is here so we can have multiple nginx controllers listening to their own ingresses only
        # default - "k8s.io/ingress-nginx"
        controllerValue: "k8s.io/ingress-nginx/${local.ingress_class}"
      }
      service : {
        annotations : {
          "metallb.universe.tf/loadBalancerIPs" : var.metallb.ip
        }
        # To have correct client IPs
        # https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
        externalTrafficPolicy : "Local"
      }
    }
  })
}