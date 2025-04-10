output "talos_version" {
  value = var.talos_version
}

output "platform" {
  value = module.image.platform
}

output "iso_url" {
  value = module.image.iso_url
}

output "installer" {
  value = module.image.installer
}

output "disk_image_url" {
  value = module.image.disk_image_url
}
