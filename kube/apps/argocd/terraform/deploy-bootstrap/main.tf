resource "helm_release" "this" {
  name      = var.release
  namespace = var.namespace

  # https://artifacthub.io/packages/helm/argo/argo-cd
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.helm_version

  wait = true
  max_history = 2

  values = [
    templatefile("${path.module}/../../helm/values-bootstrap.yaml", {})
  ]
}

data "kubernetes_secret_v1" "initial_admin_secret" {
  metadata {
    name      = "${var.release}-initial-admin-secret"
    namespace = var.namespace
  }

  binary_data = {
    password = ""
  }

  depends_on = [helm_release.this]
}