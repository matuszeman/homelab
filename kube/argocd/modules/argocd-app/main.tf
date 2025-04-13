locals {
  cluster_name                = "in-cluster"
  agrocd_apps_namespace       = var.argocd.namespace
  app_namespace               = var.namespace
  release_name                = var.release

  manifest = {
    apiVersion : "argoproj.io/v1alpha1"
    kind : "Application"
    metadata = {
      namespace : local.agrocd_apps_namespace
      name : local.release_name
      finalizers: var.argocd.preserve_resources_on_deletion ? null : [
        "resources-finalizer.argocd.argoproj.io"
      ]
    }
    spec = {
      destination = {
        name : local.cluster_name
        namespace : local.app_namespace
        #server : "https://kubernetes.default.svc"
      }
      source = {
        chart: var.chart
        repoURL : var.repo_url
        targetRevision : var.chart_version
        # https://argo-cd.readthedocs.io/en/stable/user-guide/helm/
        helm = {
          releaseName : local.release_name
          # https://github.com/argoproj/argo-cd/issues/15126
          #valuesObject: var.values_object
          values: yamlencode(var.values_object)
          skipCrds: var.skip_crds
        }
      }
      project : "default"
      syncPolicy = {
        automated = {
          prune: true
        }
        syncOptions = [
          "PruneLast=true",
          "CreateNamespace=true",
          # https://github.com/prometheus-operator/prometheus-operator/issues/4355
          "ServerSideApply=true"
        ]
      }
    }
  }
}

resource "kubectl_manifest" "this" {
  yaml_body = yamlencode(local.manifest)
}