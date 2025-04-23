module "image" {
  source = "../talos-image"
  talos_version = var.talos_version
  extensions = concat([
    "qemu-guest-agent",
    # Longhorn - https://longhorn.io/docs/1.8.1/deploy/install/#installation-requirements
    #"iscsi-tools",
    #"util-linux-tools"
  ], var.talos_additional_extensions)
}

resource "proxmox_virtual_environment_download_file" "iso" {
  content_type            = "iso"
  datastore_id            = var.pve_storage
  node_name               = var.pve_node
  file_name               = "${var.name_prefix}${var.name}.img"
  url                     = module.image.iso_url
  overwrite               = false
}