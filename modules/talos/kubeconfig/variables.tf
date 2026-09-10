variable "cluster_config" {}
variable "config_path" {}

variable "context_name" {
  description = "Name of the kubeconfig context to use."
  type        = string
  default     = "admin@talos"
}

variable "user_name" {
  description = "Name of the kubeconfig user to use."
  type        = string
  default     = "admin@talos"
}

variable "cluster_name" {
  description = "Name of the kubeconfig cluster to use."
  type        = string
  default     = "talos"
}
