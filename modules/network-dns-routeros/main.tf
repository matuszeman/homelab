resource "routeros_ip_dns_record" "statics" {
  for_each = var.static_ip_allocations

  name    = "${each.key}.${var.domain}"
  address = each.value.address
  type    = "A"
  ttl = 60
  comment = "TF"
}