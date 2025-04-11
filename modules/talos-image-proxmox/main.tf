module "image" {
  source = "../talos-image"
  talos_version = var.talos_version
}

resource "proxmox_virtual_environment_download_file" "iso" {
  content_type            = "iso"
  datastore_id            = var.pve_storage
  node_name               = var.pve_node
  file_name               = "${var.name_prefix}${var.name}.img"
  url                     = module.image.iso_url
  #checksum                = var.talos.image_hash
  #decompression_algorithm = "zst"
  #checksum_algorithm      = "sha256"
  overwrite               = false
}