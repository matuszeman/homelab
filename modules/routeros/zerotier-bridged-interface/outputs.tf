output "interface_name" {
  value = routeros_zerotier_interface.this.name
}

output "zerotier_member" {
  value = zerotier_member.this
}