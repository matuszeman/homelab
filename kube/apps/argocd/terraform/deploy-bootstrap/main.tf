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
