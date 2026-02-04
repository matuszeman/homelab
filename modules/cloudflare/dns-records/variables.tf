variable "ctx" {}

variable "domain" {
  type = string
}

variable "zone_id" {}

variable "records" {
  type = map(object({
    a = optional(list(object({
      address = string
      ttl     = optional(number, 3600)
      comment = optional(string, "")
      proxied = optional(bool, false)
    })), [])
    aaaa = optional(list(object({
      address = string
      ttl     = optional(number, 3600)
      comment = optional(string, "")
      proxied = optional(bool, false)
    })), [])
    cname = optional(list(object({
      cname   = string
      ttl     = optional(number, 3600)
      comment = optional(string, "")
    })), [])
    mx = optional(list(object({
      exchange   = string
      preference = optional(number, 10)
      ttl        = optional(number, 3600)
      comment    = optional(string, "")
    })), [])
    txt = optional(list(object({
      text    = string
      ttl     = optional(number, 3600)
      comment = optional(string, "")
    })), [])
  }))
  description = "DNS records organized by hostname with support for multiple record types"
}
