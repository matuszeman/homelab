locals {
  static_ips = {
    for name, spec in var.network.static_ips : name => spec if spec.zerotier_member != null
  }
}

resource "zerotier_member" "this" {
  for_each = local.static_ips

  name                    = "${each.key}-static"
  member_id               = each.value.zerotier_member
  network_id              = zerotier_network.this.id
  description             = "tf"
  hidden                  = false
  allow_ethernet_bridging = true
  no_auto_assign_ips      = true
  ip_assignments          = [each.value.address]
}
