locals {
  platform = "nocloud"
}

# https://factory.talos.dev/?arch=amd64&cmdline-set=true&extensions=-&extensions=siderolabs%2Fqemu-guest-agent&platform=nocloud&target=cloud&version=1.9.5
data "talos_image_factory_extensions_versions" "this" {
  talos_version = var.talos_version
  filters = {
    names = [
      "qemu-guest-agent",
    ]
  }
}

resource "talos_image_factory_schematic" "this" {
  schematic = yamlencode(
    {
      customization = {
        systemExtensions = {
          officialExtensions = data.talos_image_factory_extensions_versions.this.extensions_info[*].name
        }
      }
    }
  )
}

data "talos_image_factory_urls" "this" {
  talos_version = data.talos_image_factory_extensions_versions.this.talos_version
  schematic_id  = talos_image_factory_schematic.this.id
  platform      = local.platform
}
