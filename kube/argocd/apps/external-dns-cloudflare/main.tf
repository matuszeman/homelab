locals {
  secret_name = "${var.release}-secrets"
}

# https://github.com/kubernetes-sigs/external-dns/blob/master/docs/faq.md#which-service-and-ingress-controllers-are-supported
module "argocd" {
  source = "../../modules/argocd-app"
  argocd = var.argocd

  # https://artifacthub.io/packages/helm/bitnami/external-dns
  chart = "external-dns"
  chart_version = "8.7.11"
  repo_url = "registry-1.docker.io/bitnamicharts"
  skip_crds = !var.manage_crds
  release = var.release
  namespace = var.namespace
  values_object = {
    provider : "cloudflare"

    dryRun: var.dry_run

    txtOwnerId: var.release
    publishInternalServices: true
    #domainFilters: [
      // https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/pdns.md#domain-filter---domain-filter
      # Internal DNS only
      # see proxied: false below.
      #"matuszeman.dev",
    #],
    cloudflare: {
      #email = var.cloudflare.api_email
      secretName = local.secret_name
#      external-dns.alpha.kubernetes.io/cloudflare-proxied: "false"
#      external-dns.alpha.kubernetes.io/ttl: 300
      # IMPORTANT: https://github.com/kubernetes-sigs/external-dns/issues/1945
      # https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/cloudflare.md
      proxied: false
    }
    policy: "sync"
    ingressClassFilters: var.ingress_class_filters,
    extraArgs: merge(
      {},
      # https://github.com/kubernetes-sigs/external-dns/blob/master/pkg/apis/externaldns/types.go
      var.default_target == null ? null : { default-targets: [var.default_target] }
    )
    extraDeploy: [
      templatefile("${path.module}/sealed-secret.yaml", {
        name: local.secret_name
        encrypted_data: {
          cloudflare_api_token : var.sealed_secrets.cloudflare_api_token
        }
      }),
    ]
  }
}
