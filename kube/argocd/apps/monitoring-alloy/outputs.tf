output "backends" {
  value = {
    metrics = {
      service_monitor = {

      }
      otlp_grpc = {
        host: "${var.release}-alloy-receiver.${var.namespace}.svc.cluster.local"
        port: 4317
      }
    }
    traces = {
      otlp_grpc = {
        host: "${var.release}-alloy-receiver.${var.namespace}.svc.cluster.local"
        port: 4317
      }
    }
  }
}