# Flatten all records from the nested structure using content-based unique keys
locals {
  a_records = flatten([
    for hostname, record in var.records : [
      for idx, a_record in record.a : {
        key     = "${hostname}-${replace(a_record.address, "/[^a-zA-Z0-9]/", "-")}"
        name    = "${hostname}.${var.domain}"
        content = a_record.address
        type    = "A"
        ttl     = coalesce(a_record.ttl, var.a_defaults.ttl, 3600)
        proxied = coalesce(a_record.proxied, var.a_defaults.proxied, false)
        comment = coalesce(a_record.comment, var.a_defaults.comment, "")
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
        ttl     = coalesce(aaaa_record.ttl, var.aaaa_defaults.ttl, 3600)
        proxied = coalesce(aaaa_record.proxied, var.aaaa_defaults.proxied, false)
        comment = coalesce(aaaa_record.comment, var.aaaa_defaults.comment, "")
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
        ttl     = coalesce(cname_record.ttl, var.cname_defaults.ttl, 3600)
        comment = coalesce(cname_record.comment, var.cname_defaults.comment, "")
      }
    ]
  ])

  mx_records = flatten([
    for hostname, record in var.records : [
      for idx, mx_record in record.mx : {
        key      = "${hostname}-${coalesce(mx_record.preference, var.mx_defaults.preference, 10)}-${replace(mx_record.exchange, "/[^a-zA-Z0-9]/", "-")}"
        name     = "${hostname}.${var.domain}"
        content  = mx_record.exchange
        type     = "MX"
        priority = coalesce(mx_record.preference, var.mx_defaults.preference, 10)
        ttl      = coalesce(mx_record.ttl, var.mx_defaults.ttl, 3600)
        comment  = coalesce(mx_record.comment, var.mx_defaults.comment, "")
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
        ttl     = coalesce(txt_record.ttl, var.txt_defaults.ttl, 3600)
        comment = coalesce(txt_record.comment, var.txt_defaults.comment, "")
      }
    ]
  ])
}

locals {
  zone_id = var.zone_id
  tags    = var.record_tags ? [for key, value in var.ctx.tags : "${key}:${value}"] : []
  comment_tags = var.comment_tags ? " ${var.ctx.tags_string}" : ""
}

resource "cloudflare_dns_record" "a" {
  for_each = { for record in local.a_records : record.key => record }

  zone_id = local.zone_id
  name    = each.value.name
  content = each.value.content
  type    = each.value.type
  ttl     = each.value.proxied ? 1 : each.value.ttl
  proxied = each.value.proxied
  comment = "${each.value.comment}${local.comment_tags}"
  tags    = local.tags
}

resource "cloudflare_dns_record" "aaaa" {
  for_each = { for record in local.aaaa_records : record.key => record }

  zone_id = local.zone_id
  name    = each.value.name
  content = each.value.content
  type    = each.value.type
  ttl     = each.value.proxied ? 1 : each.value.ttl
  proxied = each.value.proxied
  comment = "${each.value.comment}${local.comment_tags}"
  tags    = local.tags
}

resource "cloudflare_dns_record" "cname" {
  for_each = { for record in local.cname_records : record.key => record }

  zone_id = local.zone_id
  name    = each.value.name
  content = each.value.content
  type    = each.value.type
  ttl     = each.value.ttl
  comment = "${each.value.comment}${local.comment_tags}"
  tags    = local.tags
}

resource "cloudflare_dns_record" "mx" {
  for_each = { for record in local.mx_records : record.key => record }

  zone_id  = local.zone_id
  name     = each.value.name
  content  = each.value.content
  type     = each.value.type
  priority = each.value.priority
  ttl      = each.value.ttl
  comment  = "${each.value.comment}${local.comment_tags}"
  tags     = local.tags
}

resource "cloudflare_dns_record" "txt" {
  for_each = { for record in local.txt_records : record.key => record }

  zone_id = local.zone_id
  name    = each.value.name
  content = each.value.content
  type    = each.value.type
  ttl     = each.value.ttl
  comment = "${each.value.comment}${local.comment_tags}"
  tags    = local.tags
}
