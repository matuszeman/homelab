locals {
  ingress_class = var.release
}

module "argocd" {
  source = "./../../modules/argocd-app"
  argocd = var.argocd

  # https://artifacthub.io/packages/helm/traefik/traefik/9.2.0
  # https://github.com/traefik/traefik-helm-chart/tree/master/traefik
  chart         = "traefik"
  chart_version = "35.0.0"
  repo_url      = "https://traefik.github.io/charts"
  release       = var.release
  namespace     = var.namespace

  skip_crds = true

  values_object = merge({
    # disables checknewversion and sendanonymoususage which is enabled by default
    globalArguments: [
      "--global.checknewversion=false"
    ]
    fullnameOverride : var.release
    instanceLabelOverride : var.release
    # change to service monitor
    # https://github.com/traefik/traefik-helm-chart/blob/master/EXAMPLES.md#use-prometheus-operator

    #     nodeSelector: {
    #       "network.node.homelab/${var.target_network}": "true"
    #     }

    service : {
      annotations : {
        "metallb.universe.tf/loadBalancerIPs" : var.metallb.ip
      }
      spec: {
        # To have correct client IPs
        # https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip
        externalTrafficPolicy: "Local"
      }
    }

    ingressClass : {
      name : local.ingress_class
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
    providers : {
      kubernetesCRD : {
        enabled : true
      }
      kubernetesIngress : {
        enabled : true
        ingressClass : var.release
        # https://github.com/kubernetes-sigs/external-dns/blob/master/docs/faq.md#which-service-and-ingress-controllers-are-supported
        publishedService : {
          enabled : true
        }
      }
    }

    experimental : {
      # enable gateway api on cluster first
      #      kubernetesGateway : {
      #        enabled : true
      #      }
    }

    ports : {
      websecure : {
        asDefault : true
      }
      # it was setting containerPort: 0
      #      http3 : {
      #        enabled : true
      #      }
    }
    logs : {
      general: {
        format: "json"
      }
      access: {
        enabled: var.monitoring.logs.access.enabled
        format: "json"
        filters = {
          statuscodes = "400-499,500-599"
        }
        fields = {
          general = {
            defaultmode = "drop"
            names = {
              ClientHost            = "keep"
              ClientUsername        = "keep"
              Duration              = "keep"
              Overhead              = "keep"
              RequestHost           = "keep"
              RequestMethod         = "keep"
              RequestPath           = "keep"
              RequestProtocol       = "keep"
              RequestContentSize    = "keep"
              OriginStatus          = "keep"
              OriginContentSize     = "keep"
              DownstreamStatus      = "keep"
              DownstreamContentSize = "keep"
            }
          }
          headers = {
            defaultmode = "drop"
            names = {
              User-Agent = "keep"
              Referer    = "keep"
            }
          }
        }
      }
    }
  }, var.monitoring.metrics.enabled == false ? null : {
    metrics : {
      otlp : {
        enabled : true
        grpc : {
          enabled : true
          endpoint : "${var.monitoring.backends.metrics.otlp_grpc.host}:${var.monitoring.backends.metrics.otlp_grpc.port}"
          insecure : true
        }
      }
    }
  }, var.monitoring.traces.enabled == false ? null : {
    tracing: {
      otlp : {
        enabled : true
        grpc : {
          enabled : true
          endpoint : "${var.monitoring.traces.otlp_grpc.host}:${var.monitoring.backends.traces.otlp_grpc.port}"
          insecure : true
        }
      }
    }
  })
}