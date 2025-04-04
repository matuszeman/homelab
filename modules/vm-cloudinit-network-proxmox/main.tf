module "cloudinit" {
  source = "../vm-cloudinit-network"

  hostname = coalesce(var.hostname, var.name)
  nics = var.nics
}

resource "proxmox_virtual_environment_file" "this" {
  content_type = "snippets"
  datastore_id = var.pve_datastore
  node_name    = var.pve_node

  source_raw {
    data = module.cloudinit.data

    file_name = "${var.name}-cloudinit-network.yaml"
  }
}