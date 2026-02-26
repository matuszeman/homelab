# https://help.mikrotik.com/docs/spaces/ROS/pages/3211299/NAT
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_firewall_nat
resource "routeros_ip_firewall_nat" "rule" {
  for_each = var.port_forwards

  comment           = "tf - ${each.key}"
  log = each.value.log
  log_prefix = each.value.log_prefix

  disabled = !each.value.enabled
  chain             = "dstnat"
  in_interface_list = var.in_interface_list
  protocol          = "tcp"
  dst_port = each.value.port
  dst_address = var.public_address

  action       = "dst-nat"
  to_addresses = var.server_address
  to_ports = each.value.port
}

resource "routeros_ip_firewall_nat" "hairpin" {
  count = var.hairpin == null ? 0 : 1

  comment           = "tf - hairpin NAT for ${var.server_address}"
  disabled = !var.hairpin.enabled
  chain             = "srcnat"

  # TODO
  out_interface_list = "LAN"
  protocol          = "tcp"
  src_address = var.hairpin.network.cidr
  dst_address = var.server_address

  action       = "masquerade"
}
