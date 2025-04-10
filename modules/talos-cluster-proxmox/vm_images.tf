resource "proxmox_virtual_environment_download_file" "talos_image" {
  content_type            = "iso"
  datastore_id            = "local"
  node_name               = var.proxmox.node_name
  file_name               = "talos-${var.talos.version}-nocloud-amd64.img"
  url                     = "https://factory.talos.dev/image/e3fab82b561b5e559cdf1c0b1e5950c0e52700b9208a2cfaa5b18454796f3a7e/${var.talos.version}/nocloud-amd64.raw.zst"
  checksum                = var.talos.image_hash
  decompression_algorithm = "zst"
  checksum_algorithm      = "sha256"
  overwrite               = false
}
