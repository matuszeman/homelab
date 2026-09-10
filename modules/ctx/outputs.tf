# output "id" {
#   value = var.name
# }

locals {
  tags = {
    name       = var.name
    repo       = var.repo
    repo_path  = var.repo_path
  }
}

output "name" {
  value = var.name
}

output "env" {
  value = var.env
}

output "cluster" {
  value = var.cluster
}

output "repo" {
  value = var.repo
}

output "repo_path" {
  value = var.repo_path
}

output "tags" {
  value = local.tags
}

output "tags_string" {
  value = join(" ", [for k, v in local.tags : "${k}=${v}"])
}
