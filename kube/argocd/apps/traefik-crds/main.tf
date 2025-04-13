module "argocd" {
  source = "./../../modules/argocd-app"
  argocd = var.argocd

  # https://artifacthub.io/packages/helm/traefik/traefik-crds
  chart = "traefik-crds"
  chart_version = "1.6.0"
  repo_url = "https://traefik.github.io/charts"
  release = "traefik-crds"
  namespace = var.namespace
}