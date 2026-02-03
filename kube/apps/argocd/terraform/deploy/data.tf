data "kubernetes_secret_v1" "initial_admin_secret" {
  metadata {
    name      = "${var.release}-initial-admin-secret"
    namespace = var.namespace
  }

  binary_data = {
    password = ""
  }
}