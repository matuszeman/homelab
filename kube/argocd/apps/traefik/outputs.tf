output "ingress" {
  value = {
    class_name: local.ingress_class
    annotations: {
      # this is set as default
      #"traefik.ingress.kubernetes.io/router.entrypoints": "websecure"
    }
  }
}