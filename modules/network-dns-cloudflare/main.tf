resource "cloudflare_record" "static_ips" {
  for_each = var.network.static_ips

  zone_id = var.cloudflare_zone_id
  name    = "${each.key}.${var.network.domain}"
  value   = each.value
  type    = "A"
  ttl     = 60
}