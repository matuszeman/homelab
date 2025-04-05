resource "proxmox_virtual_environment_download_file" "talos_image" {
  content_type            = "iso"
  datastore_id            = "local"
  node_name               = var.proxmox.node_name
  file_name               = "talos-v1.9.5-nocloud-amd64.img"
  url                     = "https://factory.talos.dev/image/e3fab82b561b5e559cdf1c0b1e5950c0e52700b9208a2cfaa5b18454796f3a7e/v1.9.5/nocloud-amd64.raw.zst"
  checksum                = "221eb29d3d6c93167255117b85f3e2d3074153e72e23d7d49195e3e693127c3e"
  decompression_algorithm = "zst"
  checksum_algorithm      = "sha256"
  overwrite               = false
}
