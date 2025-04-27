# https://github.com/bitnami-labs/sealed-secrets
# https://artifacthub.io/packages/helm/bitnami-labs/sealed-secrets

# kubectl create secret generic mysecret --dry-run=client -o yaml > mysecret.yaml
# kubeseal --scope namespace-wide -f mysecret.yaml -w mysealedsecret.yaml

module "argocd" {
  source = "../../modules/argocd-app"
  argocd        = var.argocd

  chart         = "sealed-secrets"
  chart_version = "2.17.2"
  repo_url      = "https://bitnami-labs.github.io/sealed-secrets"
  release       = "sealed-secrets"
  namespace     = var.namespace

  values_object_override = var.helm_values_override
  values_object = {
    # kubeseal cli uses sealed-secrets-controller as default
    # error: cannot get sealed secret service: services "sealed-secrets-controller" not found.
    #Please, use the flag --controller-name and --controller-namespace to set up the name and namespace of the sealed secrets controller
    fullnameOverride : "sealed-secrets-controller"
  }
}