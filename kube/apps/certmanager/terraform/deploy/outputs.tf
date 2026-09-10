output "helm_values" {
  value = templatefile("${path.module}/../../helm/values-tf.yaml", {
    release   = var.release
    namespace   = var.namespace
  })
}