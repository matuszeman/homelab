output "talos_version" {
  value = var.talos_version
}

output "platform" {
  value = local.platform
}

output "iso_url" {
  value = data.talos_image_factory_urls.this.urls.iso
}

output "installer" {
  value = data.talos_image_factory_urls.this.urls.installer
}

output "disk_image_url" {
  value = data.talos_image_factory_urls.this.urls.disk_image
}
