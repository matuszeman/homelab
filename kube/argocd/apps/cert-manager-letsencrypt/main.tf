# https://cert-manager.io/docs/installation/helm/#helm-installation

locals {
  secret_name = "${var.release}-secrets"
}

module "argocd" {
  source = "./../../modules/argocd-app"
  argocd = var.argocd

  chart = "cert-manager"
  chart_version = "1.17.1"
  repo_url = "https://charts.jetstack.io"
  release = var.release
  namespace = var.namespace

  skip_crds = !var.manage_crds

  values_object = {
    # https://cert-manager.io/docs/installation/helm/#option-1-installing-crds-with-kubectl
    crds : {
      enabled: var.manage_crds
    }
    global: {
#       leaderElection: {
#         namespace = var.namespace
#       }
    }
    #enableCertificateOwnerRef: true
    extraObjects: [
      templatefile("${path.module}/sealed-secret.yaml", {
        name: local.secret_name
        encrypted_data: {
          cloudflare_api_token : var.sealed_secrets.cloudflare_api_token
        }
      }),
      templatefile("${path.module}/cluster-issuer.yaml", {
        name: var.cluster_issuer_staging
        release: var.release
        server: "https://acme-staging-v02.api.letsencrypt.org/directory"
        secret_name = local.secret_name
        email: var.letsencrypt.email
        cloudflare: var.dns_resolver.cloudflare
      }),
      templatefile("${path.module}/cluster-issuer.yaml", {
        name: var.cluster_issuer
        release: var.release
        server: "https://acme-v02.api.letsencrypt.org/directory"
        secret_name = local.secret_name
        email: var.letsencrypt.email
        cloudflare: var.dns_resolver.cloudflare
      }),
    ]
  }
}
