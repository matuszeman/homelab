# Flatten all records from the nested structure using content-based unique keys
locals {
  a_records = flatten([
    for hostname, record in var.records : [
      for idx, a_record in record.a : {
        key     = "${hostname}-${replace(a_record.address, "/[^a-zA-Z0-9]/", "-")}"
        name    = "${hostname}.${var.domain}"
        address = a_record.address
        ttl     = coalesce(a_record.ttl, var.a_defaults.ttl)
        comment = coalesce(a_record.comment, var.a_defaults.comment)
      }
    ]
  ])

  aaaa_records = flatten([
    for hostname, record in var.records : [
      for idx, aaaa_record in record.aaaa : {
        key     = "${hostname}-${replace(aaaa_record.address, "/[^a-zA-Z0-9]/", "-")}"
        name    = "${hostname}.${var.domain}"
        address = aaaa_record.address
        ttl     = coalesce(aaaa_record.ttl, var.aaaa_defaults.ttl)
        comment = coalesce(aaaa_record.comment, var.aaaa_defaults.comment)
      }
    ]
  ])

  cname_records = flatten([
    for hostname, record in var.records : [
      for idx, cname_record in record.cname : {
        key     = "${hostname}-${replace(cname_record.cname, "/[^a-zA-Z0-9]/", "-")}"
        name    = "${hostname}.${var.domain}"
        cname   = cname_record.cname
        ttl     = coalesce(cname_record.ttl, var.cname_defaults.ttl)
        comment = coalesce(cname_record.comment, var.cname_defaults.comment)
      }
    ]
  ])

  mx_records = flatten([
    for hostname, record in var.records : [
      for idx, mx_record in record.mx : {
        key        = "${hostname}-${coalesce(mx_record.preference, var.mx_defaults.preference)}-${replace(mx_record.exchange, "/[^a-zA-Z0-9]/", "-")}"
        name       = "${hostname}.${var.domain}"
        exchange   = mx_record.exchange
        preference = coalesce(mx_record.preference, var.mx_defaults.preference)
        ttl        = coalesce(mx_record.ttl, var.mx_defaults.ttl)
        comment    = coalesce(mx_record.comment, var.mx_defaults.comment)
      }
    ]
  ])

  txt_records = flatten([
    for hostname, record in var.records : [
      for idx, txt_record in record.txt : {
        key     = "${hostname}-${substr(md5(txt_record.text), 0, 8)}"
        name    = "${hostname}.${var.domain}"
        text    = txt_record.text
        ttl     = coalesce(txt_record.ttl, var.txt_defaults.ttl)
        comment = coalesce(txt_record.comment, var.txt_defaults.comment)
      }
    ]
  ])
}

resource "routeros_ip_dns_record" "a" {
  for_each = { for record in local.a_records : record.key => record }

  name    = each.value.name
  address = each.value.address
  type    = "A"
  ttl     = each.value.ttl
  comment = "${each.value.comment} ${var.ctx.tags_string}"
}

resource "routeros_ip_dns_record" "aaaa" {
  for_each = { for record in local.aaaa_records : record.key => record }

  name    = each.value.name
  address = each.value.address
  type    = "AAAA"
  ttl     = each.value.ttl
  comment = "${each.value.comment} ${var.ctx.tags_string}"
}

resource "routeros_ip_dns_record" "cname" {
  for_each = { for record in local.cname_records : record.key => record }

  name    = each.value.name
  cname   = each.value.cname
  type    = "CNAME"
  ttl     = each.value.ttl
  comment = "${each.value.comment} ${var.ctx.tags_string}"
}

resource "routeros_ip_dns_record" "mx" {
  for_each = { for record in local.mx_records : record.key => record }

  name       = each.value.name
  mx_exchange   = each.value.exchange
  mx_preference = each.value.preference
  type       = "MX"
  ttl        = each.value.ttl
  comment    = "${each.value.comment} ${var.ctx.tags_string}"
}

resource "routeros_ip_dns_record" "txt" {
  for_each = { for record in local.txt_records : record.key => record }

  name    = each.value.name
  text    = each.value.text
  type    = "TXT"
  ttl     = each.value.ttl
  comment = "${each.value.comment} ${var.ctx.tags_string}"
}

