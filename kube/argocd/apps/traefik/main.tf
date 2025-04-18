module "argocd" {
  source = "./../../modules/argocd-app"
  argocd = var.argocd

  # https://artifacthub.io/packages/helm/traefik/traefik/9.2.0
  chart = "traefik"
  chart_version = "35.0.0"
  repo_url = "https://traefik.github.io/charts"
  release = var.release
  namespace = var.namespace

  skip_crds = true

  values_object = {
#     nodeSelector: {
#       "network.node.homelab/${var.target_network}": "true"
#     }

    service: {
      annotations: {
        "metallb.universe.tf/loadBalancerIPs": var.metallb.ip
      }
    }

    ingressClass: {
      name : var.release
      isDefaultClass : false
    }

    # IngressRoute is not supported by external-dns
#    ingressRoute: {
#      dashboard: {
#        annotations: {
#          "kubernetes.io/ingress.class": "${var.target_network}-traefik"
#        }
#        enabled : true
#      }
#    }

    # https://github.com/traefik/traefik-helm-chart/blob/master/traefik/values.yaml#L209C1-L209C10
    providers: {
      kubernetesCRD: {
        enabled: true
      }
      kubernetesIngress: {
        enabled: true
        ingressClass: var.release
        # https://github.com/kubernetes-sigs/external-dns/blob/master/docs/faq.md#which-service-and-ingress-controllers-are-supported
        publishedService: {
          enabled: true
        }
      }
    }

    experimental: {
      # enable gateway api on cluster first
      #      kubernetesGateway : {
      #        enabled : true
      #      }
    }

    ports: {
      websecure : {
        asDefault : true
      }
      # it was setting containerPort: 0
      #      http3 : {
      #        enabled : true
      #      }
    }
  }
}