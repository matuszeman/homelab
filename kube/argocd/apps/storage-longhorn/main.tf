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

  values_object_override = var.helm_values_override
  values_object = merge({
    nameOverride : var.release
    namespaceOverride : var.namespace
    # allow csi driver to be provisioned on all nodes
    # https://longhorn.io/docs/archives/1.2.4/references/settings/#kubernetes-taint-toleration
    # https://longhorn.io/docs/archives/1.2.4/advanced-resources/deploy/taint-toleration/#setting-up-taints-and-tolerations-after-longhorn-has-been-installed
    defaultSettings: {
      taintToleration: ":"
    }
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