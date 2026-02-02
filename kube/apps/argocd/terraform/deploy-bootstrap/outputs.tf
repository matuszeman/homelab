output "namespace" {
  value = var.namespace
}

output "initial_admin" {
  value = {
    username = "admin"
    password = base64decode(data.kubernetes_secret_v1.initial_admin_secret.binary_data["password"])
  }
}