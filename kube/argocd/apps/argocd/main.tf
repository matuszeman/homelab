resource "helm_release" "this" {
  name      = var.release
  namespace = var.namespace

  # https://artifacthub.io/packages/helm/argo/argo-cd
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.8.23"

  wait = true
  max_history = 2

  values = [
    templatefile("${path.module}/values.yaml", {
      release = var.release
      ingress = {
        domain = var.ingress.domain
        ingress_class = var.ingress.class
        cert_manager_cluster_issuer = var.ingress.cert_manager_cluster_issuer
        traefik_entrypoints = "websecure"
      }
    }),
    yamlencode({
      configs: {
        repositories: {
          for key, repo in var.repos : key => {
            type = repo.type
            url = repo.url
          }
        }
      }
    }),
    yamlencode({
      extraObjects: [
        for key, spec in var.repo_creds :
          templatefile("${path.module}/repo-creds.yaml", {
            name: "{{ .Release.Name }}-${key}"
            namespace: var.namespace
            type: spec.type
            url: spec.url
            encrypted_data: spec.sealedSecrets
          })
      ]
    }),
    yamlencode(var.helm_values_override)
  ]
}