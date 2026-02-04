# Flatten all records from the nested structure using content-based unique keys
locals {
  a_records = flatten([
    for hostname, record in var.records : [
      for idx, a_record in record.a : {
        key     = "${hostname}-a-${replace(a_record.address, "/[^a-zA-Z0-9]/", "-")}"
        name    = "${hostname}.${var.domain}"
        address = a_record.address
        ttl     = a_record.ttl
        comment = a_record.comment
      }
    ]
  ])

  aaaa_records = flatten([
    for hostname, record in var.records : [
      for idx, aaaa_record in record.aaaa : {
        key     = "${hostname}-aaaa-${replace(aaaa_record.address, "/[^a-zA-Z0-9]/", "-")}"
        name    = "${hostname}.${var.domain}"
        address = aaaa_record.address
        ttl     = aaaa_record.ttl
        comment = aaaa_record.comment
      }
    ]
  ])

  cname_records = flatten([
    for hostname, record in var.records : [
      for idx, cname_record in record.cname : {
        key     = "${hostname}-cname-${replace(cname_record.cname, "/[^a-zA-Z0-9]/", "-")}"
        name    = "${hostname}.${var.domain}"
        cname   = cname_record.cname
        ttl     = cname_record.ttl
        comment = cname_record.comment
      }
    ]
  ])

  mx_records = flatten([
    for hostname, record in var.records : [
      for idx, mx_record in record.mx : {
        key        = "${hostname}-mx-${mx_record.preference}-${replace(mx_record.exchange, "/[^a-zA-Z0-9]/", "-")}"
        name       = "${hostname}.${var.domain}"
        exchange   = mx_record.exchange
        preference = mx_record.preference
        ttl        = mx_record.ttl
        comment    = mx_record.comment
      }
    ]
  ])

  txt_records = flatten([
    for hostname, record in var.records : [
      for idx, txt_record in record.txt : {
        key     = "${hostname}-txt-${substr(md5(txt_record.text), 0, 8)}"
        name    = "${hostname}.${var.domain}"
        text    = txt_record.text
        ttl     = txt_record.ttl
        comment = txt_record.comment
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

