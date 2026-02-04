output "a_records" {
  description = "Created A records"
  value       = cloudflare_dns_record.a
}

output "aaaa_records" {
  description = "Created AAAA records"
  value       = cloudflare_dns_record.aaaa
}

output "cname_records" {
  description = "Created CNAME records"
  value       = cloudflare_dns_record.cname
}

output "mx_records" {
  description = "Created MX records"
  value       = cloudflare_dns_record.mx
}

output "txt_records" {
  description = "Created TXT records"
  value       = cloudflare_dns_record.txt
}

output "all_records" {
  description = "All created DNS records organized by type"
  value = {
    a     = cloudflare_dns_record.a
    aaaa  = cloudflare_dns_record.aaaa
    cname = cloudflare_dns_record.cname
    mx    = cloudflare_dns_record.mx
    txt   = cloudflare_dns_record.txt
  }
}

# output "zone_id" {
#   description = "Cloudflare zone ID for the domain"
#   value       = data.cloudflare_zone.domain.id
# }

