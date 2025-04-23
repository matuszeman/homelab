module "argocd" {
  source = "./../../modules/argocd-app"
  argocd = var.argocd

  # https://artifacthub.io/packages/helm/longhorn/longhorn
  # https://github.com/longhorn/charts/tree/master/charts/longhorn
  chart         = "longhorn"
  chart_version = "1.8.1"
  repo_url      = "https://charts.longhorn.io"
  release       = var.release
  namespace     = var.namespace

  skip_crds = !var.manage_crds

  values_object = merge({
    nameOverride : var.release
    namespaceOverride : var.namespace
    persistence: {
      defaultClass: false
      defaultClassReplicaCount: 1
    }
    preUpgradeChecker: {
      jobEnabled: false
    }
    longhornUI: {
      replicas: 1
    }
    ingress: {
      enabled: var.ingress.enabled
      host: var.ingress.host
      ingressClassName: var.ingress.controller.class_name
      tls: true
      tlsSecret: "${var.release}-ingress-tls"
      annotations: merge(
        var.ingress.controller.annotations,
        {
          "cert-manager.io/cluster-issuer": var.ingress.cert_manager_cluster_issuer
        }
      )
    }
  })
}