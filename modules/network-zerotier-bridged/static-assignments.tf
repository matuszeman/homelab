locals {
  static_ips = {
    for name, spec in var.network.static_ips : name => spec if spec.zerotier_member != null
  }
}

resource "zerotier_member" "this" {
  for_each = local.static_ips

  name                    = "static-${each.key}"
  member_id               = each.value.zerotier_member.id
  network_id              = zerotier_network.this.id
  authorized              = each.value.zerotier_member.authorized
  description             = "tf"
  hidden                  = false
  allow_ethernet_bridging = false
  no_auto_assign_ips      = true
  ip_assignments          = [each.value.address]
}
