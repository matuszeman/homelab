locals {
  ingress_class_public = "traefik-public"
  ingress_class_private = "traefik-private"
  system_namespace = kubernetes_namespace.this.metadata.0.name
  cert_manager_cluster_issuer = "letsencrypt"
  cert_manager_cluster_issuer_staging = "letsencrypt-staging"
}

resource "kubernetes_namespace" "this" {
  metadata {
    name = "system"
    labels = {
      # metallb-speaker could not startup because of these errors:
      # pods "metallb-speaker-v4b2v" is forbidden: violates PodSecurity "baseline:latest": non-default capabilities (containers "speaker",  │
      # "frr" must not include "NET_ADMIN", "NET_RAW", "SYS_ADMIN" in securityContext.capabilities.add), host namespaces (hostNetwork=true), hostPort (containers "speaker", "frr-metrics" use hostPorts 7472, 7 │
      # 473, 7946)
      # https://github.com/siderolabs/talos/issues/10291#issuecomment-2639094906
      "pod-security.kubernetes.io/audit": "privileged"
      "pod-security.kubernetes.io/enforce": "privileged"
      "pod-security.kubernetes.io/enforce-version": "latest"
      "pod-security.kubernetes.io/warn": "privileged"
    }
  }
}

# Get admin password:
# kubectl -n system get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
module "argocd" {
  #source = "git::https://github.com/matuszeman/homelab.git//kube/argocd/apps/argocd?depth=1&ref=1.0.0"
  source = "../../../kube/argocd/apps/argocd"

  namespace = local.system_namespace
  release = "argocd"

  ingress = {
    domain = local.argocd.domain
    class = local.ingress_class_private
    cert_manager_cluster_issuer = local.cert_manager_cluster_issuer
  }

  repos = local.argocd.repos
  repo_creds = local.argocd.repo_creds
}

# Check arp
# arp -a
module "metallb" {
  #source = "git::https://github.com/matuszeman/homelab.git//kube/argocd/apps/metallb?depth=1&ref=1.0.0"
  source = "../../../kube/argocd/apps/metallb"

  argocd = module.argocd
  namespace = local.system_namespace

  networks = var.networks
}

module "traefik-crds" {
  #source = "git::https://github.com/matuszeman/homelab.git//kube/argocd/apps/traefik-crds?depth=1&ref=1.0.0"
  source = "../../../kube/argocd/apps/traefik-crds"

  argocd = module.argocd
  namespace = local.system_namespace
}

module "traefik-private" {
  #source = "git::https://github.com/matuszeman/homelab.git//kube/argocd/apps/traefik?depth=1&ref=1.0.0"
  source = "../../../kube/argocd/apps/traefik"

  argocd = module.argocd
  namespace = local.system_namespace

  release = local.ingress_class_private
  metallb = {
    ip = local.traefik_private.metallb_ip
  }
}
module "external-dns-cloudflare-private" {
  #source = "git::https://github.com/matuszeman/homelab.git//kube/argocd/apps/external-dns-cloudflare?depth=1&ref=1.0.0"
  source = "../../../kube/argocd/apps/external-dns-cloudflare"

  argocd = module.argocd
  namespace = local.system_namespace
  release = "external-dns-cloudflare-private"
  # only one release can manage crds
  manage_crds = true

  dry_run = false
  ingress_class_filters = [
    local.ingress_class_private
  ]
  sealed_secrets = {
    cloudflare_api_token = local.sealed_secrets.cloudflare_api_token
  }
}

module "traefik-public" {
  #source = "git::https://github.com/matuszeman/homelab.git//kube/argocd/apps/traefik?depth=1&ref=1.0.0"
  source = "../../../kube/argocd/apps/traefik"

  argocd = module.argocd
  namespace = local.system_namespace

  release = local.ingress_class_public
  metallb = {
    ip = local.traefik_public.metallb_ip
  }
}
module "external-dns-cloudflare-public" {
  #source = "git::https://github.com/matuszeman/homelab.git//kube/argocd/apps/external-dns-cloudflare?depth=1&ref=1.0.0"
  source = "../../../kube/argocd/apps/external-dns-cloudflare"

  argocd = module.argocd
  namespace = local.system_namespace
  release = "external-dns-cloudflare-public"
  # only one release can manage crds
  manage_crds = false

  dry_run = false
  ingress_class_filters = [
    local.ingress_class_public
  ]
  default_target = local.public_ip
  sealed_secrets = {
    cloudflare_api_token = local.sealed_secrets.cloudflare_api_token
  }
}


module "sealed-secrets" {
  #source = "git::https://github.com/matuszeman/homelab.git//kube/argocd/apps/sealed-secrets?depth=1&ref=1.0.0"
  source = "../../../kube/argocd/apps/sealed-secrets"

  argocd = module.argocd
  namespace = local.system_namespace
}

module "cert-manager-letsencrypt-cloudflare" {
  #source = "git::https://github.com/matuszeman/homelab.git//kube/argocd/apps/cert-manager-letsencrypt?depth=1&ref=1.0.0"
  source = "../../../kube/argocd/apps/cert-manager-letsencrypt"

  argocd = module.argocd
  namespace = local.system_namespace
  release = "cert-manager-letsencrypt-cloudflare"

  # only one release can manage crds
  manage_crds = true

  cluster_issuer = local.cert_manager_cluster_issuer
  cluster_issuer_staging = local.cert_manager_cluster_issuer_staging
  letsencrypt = {
    email = local.letsencrypt_email
  }
  dns_resolver = {
    cloudflare = {
      email = local.cloudflare_email
    }
  }
  sealed_secrets = {
    cloudflare_api_token = local.sealed_secrets.cloudflare_api_token
  }
}