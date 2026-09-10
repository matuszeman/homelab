output "a_records" {
  description = "Created A records"
  value       = routeros_ip_dns_record.a
}

output "aaaa_records" {
  description = "Created AAAA records"
  value       = routeros_ip_dns_record.aaaa
}

output "cname_records" {
  description = "Created CNAME records"
  value       = routeros_ip_dns_record.cname
}

output "mx_records" {
  description = "Created MX records"
  value       = routeros_ip_dns_record.mx
}

output "txt_records" {
  description = "Created TXT records"
  value       = routeros_ip_dns_record.txt
}

output "all_records" {
  description = "All created DNS records organized by type"
  value = {
    a     = routeros_ip_dns_record.a
    aaaa  = routeros_ip_dns_record.aaaa
    cname = routeros_ip_dns_record.cname
    mx    = routeros_ip_dns_record.mx
    txt   = routeros_ip_dns_record.txt
  }
}
