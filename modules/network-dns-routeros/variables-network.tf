variable "name" {
  type = string
}
variable "domain" {
  description = "Unique network/domain name"
}
variable "static_ip_allocations" {
  type = map(object({
    address = string
    mac = string
  }))
}
