resource "routeros_ip_dns_record" "statics" {
  for_each = var.network.static_ips

  name    = "${each.key}.${var.network.domain}"
  address = each.value.address
  type    = "A"
  ttl     = 60
  comment = "TF"
}