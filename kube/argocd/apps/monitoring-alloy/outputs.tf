output "services" {
  value = {
    metrics = {
      otlp_grpc = {
        host: "${var.release}-alloy-receiver.${var.namespace}.svc.cluster.local"
        port: 4317
      }
    }
  }
}