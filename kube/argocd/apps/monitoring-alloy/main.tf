locals {
  secret_name = var.release
}

module "argocd-app" {
  source = "../../modules/argocd-app"
  argocd        = var.argocd

  repo_url      = "https://grafana.github.io/helm-charts"
  chart         = "k8s-monitoring"
  chart_version = "2.0.25"
  namespace     = var.namespace
  release       = var.release

  values_object_override = var.helm_values_override
  values_object = merge(yamldecode(templatefile("${path.module}/values.yaml", {
    fullnameOverride: var.release
    cluster_name = var.cluster_name
    secret_name = local.secret_name
    secret_namespace = var.namespace
    secret_access_token_key = "access_token"
  })), {
    extraObjects: [
      yamldecode(templatefile("${path.module}/sealed-secret.yaml", {
        name: local.secret_name
        encrypted_data: var.sealed_secrets
      })),
    ]
  })
}

