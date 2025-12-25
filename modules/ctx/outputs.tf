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

output "tags" {
  value = local.tags
}

output "tags_string" {
  value = join(" ", [for k, v in local.tags : "${k}=${v}"])
}
