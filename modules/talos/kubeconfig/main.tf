resource "talos_cluster_kubeconfig" "this" {
  client_configuration = var.cluster_config.client_configuration
  node                 = var.cluster_config.vip_dns
}

locals {
  kubeconfig_raw = yamldecode(talos_cluster_kubeconfig.this.kubeconfig_raw)
  kubeconfig = merge(
    local.kubeconfig_raw,
    {
      contexts = [for ctx in local.kubeconfig_raw.contexts : merge(ctx, { name = var.context_name, context = merge(ctx.context, { cluster = var.cluster_name, user = var.user_name }) })]
      users    = [for usr in local.kubeconfig_raw.users : merge(usr, { name = var.user_name })]
      clusters = [for cl in local.kubeconfig_raw.clusters : merge(cl, { name = var.cluster_name })]
      "current-context" = var.context_name
    }
  )
}

resource "local_file" "version_config" {
  content         = yamlencode(local.kubeconfig)
  filename        = var.config_path
  file_permission = "600"
}
