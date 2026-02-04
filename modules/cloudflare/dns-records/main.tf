# Flatten all records from the nested structure using content-based unique keys
locals {
  a_records = flatten([
    for hostname, record in var.records : [
      for idx, a_record in record.a : {
        key     = "${hostname}-${replace(a_record.address, "/[^a-zA-Z0-9]/", "-")}"
        name    = "${hostname}.${var.domain}"
        content = a_record.address
        type    = "A"
        ttl     = a_record.ttl
        proxied = a_record.proxied
        comment = a_record.comment
      }
    ]
  ])

  aaaa_records = flatten([
    for hostname, record in var.records : [
      for idx, aaaa_record in record.aaaa : {
        key     = "${hostname}-${replace(aaaa_record.address, "/[^a-zA-Z0-9]/", "-")}"
        name    = "${hostname}.${var.domain}"
        content = aaaa_record.address
        type    = "AAAA"
        ttl     = aaaa_record.ttl
        proxied = aaaa_record.proxied
        comment = aaaa_record.comment
      }
    ]
  ])

  cname_records = flatten([
    for hostname, record in var.records : [
      for idx, cname_record in record.cname : {
        key     = "${hostname}-${replace(cname_record.cname, "/[^a-zA-Z0-9]/", "-")}"
        name    = "${hostname}.${var.domain}"
        content = cname_record.cname
        type    = "CNAME"
        ttl     = cname_record.ttl
        comment = cname_record.comment
      }
    ]
  ])

  mx_records = flatten([
    for hostname, record in var.records : [
      for idx, mx_record in record.mx : {
        key      = "${hostname}-${mx_record.preference}-${replace(mx_record.exchange, "/[^a-zA-Z0-9]/", "-")}"
        name     = "${hostname}.${var.domain}"
        content  = mx_record.exchange
        type     = "MX"
        priority = mx_record.preference
        ttl      = mx_record.ttl
        comment  = mx_record.comment
      }
    ]
  ])

  txt_records = flatten([
    for hostname, record in var.records : [
      for idx, txt_record in record.txt : {
        key     = "${hostname}-${substr(md5(txt_record.text), 0, 8)}"
        name    = "${hostname}.${var.domain}"
        content = txt_record.text
        type    = "TXT"
        ttl     = txt_record.ttl
        comment = txt_record.comment
      }
    ]
  ])
}

# data "cloudflare_zone" "domain" {
#   name = var.domain
# }

locals {
  zone_id = var.zone_id
}

resource "cloudflare_dns_record" "a" {
  for_each = { for record in local.a_records : record.key => record }

  zone_id = local.zone_id
  name    = each.value.name
  content = each.value.content
  type    = each.value.type
  ttl     = each.value.proxied ? 1 : each.value.ttl
  proxied = each.value.proxied
  comment = "${each.value.comment} ${var.ctx.tags_string}"
}

resource "cloudflare_dns_record" "aaaa" {
  for_each = { for record in local.aaaa_records : record.key => record }

  zone_id = local.zone_id
  name    = each.value.name
  content = each.value.content
  type    = each.value.type
  ttl     = each.value.proxied ? 1 : each.value.ttl
  proxied = each.value.proxied
  comment = "${each.value.comment} ${var.ctx.tags_string}"
}

resource "cloudflare_dns_record" "cname" {
  for_each = { for record in local.cname_records : record.key => record }

  zone_id = local.zone_id
  name    = each.value.name
  content = each.value.content
  type    = each.value.type
  ttl     = each.value.ttl
  comment = "${each.value.comment} ${var.ctx.tags_string}"
}

resource "cloudflare_dns_record" "mx" {
  for_each = { for record in local.mx_records : record.key => record }

  zone_id  = local.zone_id
  name     = each.value.name
  content  = each.value.content
  type     = each.value.type
  priority = each.value.priority
  ttl      = each.value.ttl
  comment  = "${each.value.comment} ${var.ctx.tags_string}"
}

resource "cloudflare_dns_record" "txt" {
  for_each = { for record in local.txt_records : record.key => record }

  zone_id = local.zone_id
  name    = each.value.name
  content = each.value.content
  type    = each.value.type
  ttl     = each.value.ttl
  comment = "${each.value.comment} ${var.ctx.tags_string}"
}
