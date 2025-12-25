resource "zerotier_identity" "this" {}

resource "routeros_zerotier" "this" {
  comment    = "tf - ZeroTier Central controller - https://my.zerotier.com/"
  disabled = false
  identity   = zerotier_identity.this.private_key
  interfaces = ["all"]
  name       = var.name
}
