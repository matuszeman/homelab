# Flatten all records from the nested structure using content-based unique keys
locals {
  base_domain = var.domain != null ? "${var.domain}.${var.zone_name}" : var.zone_name

  # Helper function to clean wildcard hostnames
  clean_wildcard_name = {
    for hostname in keys(var.records) : hostname => (
      hostname == "@" ? local.base_domain : (
        startswith(hostname, "*") ? (
          hostname == "*" ? local.base_domain : "${trimprefix(trimprefix(hostname, "*"), ".")}.${local.base_domain}"
        ) : "${hostname}.${local.base_domain}"
      )
    )
  }

  a_records = flatten([
    for hostname, record in var.records : [
      for idx, a_record in record.a : {
        key          = "${hostname}-${replace(a_record.value, "/[^a-zA-Z0-9]/", "-")}"
        name         = local.clean_wildcard_name[hostname]
        address      = templatestring(a_record.value, var.placeholders)
        ttl          = coalesce(a_record.ttl, var.defaults.a.ttl)
        comment      = coalesce(a_record.comment, var.defaults.a.comment)
        is_wildcard  = startswith(hostname, "*")
      }
    ]
  ])

  aaaa_records = flatten([
    for hostname, record in var.records : [
      for idx, aaaa_record in record.aaaa : {
        key          = "${hostname}-${replace(aaaa_record.value, "/[^a-zA-Z0-9]/", "-")}"
        name         = local.clean_wildcard_name[hostname]
        address      = templatestring(aaaa_record.value, var.placeholders)
        ttl          = coalesce(aaaa_record.ttl, var.defaults.aaaa.ttl)
        comment      = coalesce(aaaa_record.comment, var.defaults.aaaa.comment)
        is_wildcard  = startswith(hostname, "*")
      }
    ]
  ])

  cname_records = flatten([
    for hostname, record in var.records : [
      for idx, cname_record in record.cname : {
        key          = "${hostname}-${replace(cname_record.value, "/[^a-zA-Z0-9]/", "-")}"
        name         = local.clean_wildcard_name[hostname]
        cname        = templatestring(cname_record.value, var.placeholders)
        ttl          = coalesce(cname_record.ttl, var.defaults.cname.ttl)
        comment      = coalesce(cname_record.comment, var.defaults.cname.comment)
        is_wildcard  = startswith(hostname, "*")
      }
    ]
  ])

  mx_records = flatten([
    for hostname, record in var.records : [
      for idx, mx_record in record.mx : {
        key          = "${hostname}-${coalesce(mx_record.preference, var.defaults.mx.preference)}-${replace(mx_record.value, "/[^a-zA-Z0-9]/", "-")}"
        name         = local.clean_wildcard_name[hostname]
        exchange     = templatestring(mx_record.value, var.placeholders)
        preference   = coalesce(mx_record.preference, var.defaults.mx.preference)
        ttl          = coalesce(mx_record.ttl, var.defaults.mx.ttl)
        comment      = coalesce(mx_record.comment, var.defaults.mx.comment)
        is_wildcard  = startswith(hostname, "*")
      }
    ]
  ])

  txt_records = flatten([
    for hostname, record in var.records : [
      for idx, txt_record in record.txt : {
        key          = "${hostname}-${substr(md5(txt_record.value), 0, 8)}"
        name         = local.clean_wildcard_name[hostname]
        text         = templatestring(txt_record.value, var.placeholders)
        ttl          = coalesce(txt_record.ttl, var.defaults.txt.ttl)
        comment      = coalesce(txt_record.comment, var.defaults.txt.comment)
        is_wildcard  = startswith(hostname, "*")
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

  match_subdomain = each.value.is_wildcard ? true : null
}

resource "routeros_ip_dns_record" "aaaa" {
  for_each = { for record in local.aaaa_records : record.key => record }

  name    = each.value.name
  address = each.value.address
  type    = "AAAA"
  ttl     = each.value.ttl
  comment = "${each.value.comment} ${var.ctx.tags_string}"

  match_subdomain = each.value.is_wildcard ? true : null
}

resource "routeros_ip_dns_record" "cname" {
  for_each = { for record in local.cname_records : record.key => record }

  name    = each.value.name
  cname   = each.value.cname
  type    = "CNAME"
  ttl     = each.value.ttl
  comment = "${each.value.comment} ${var.ctx.tags_string}"

  match_subdomain = each.value.is_wildcard ? true : null
}

resource "routeros_ip_dns_record" "mx" {
  for_each = { for record in local.mx_records : record.key => record }

  name       = each.value.name
  mx_exchange   = each.value.exchange
  mx_preference = each.value.preference
  type       = "MX"
  ttl        = each.value.ttl
  comment    = "${each.value.comment} ${var.ctx.tags_string}"

  match_subdomain = each.value.is_wildcard ? true : null
}

resource "routeros_ip_dns_record" "txt" {
  for_each = { for record in local.txt_records : record.key => record }

  name    = each.value.name
  text    = each.value.text
  type    = "TXT"
  ttl     = each.value.ttl
  comment = "${each.value.comment} ${var.ctx.tags_string}"

  match_subdomain = each.value.is_wildcard ? true : null
}

