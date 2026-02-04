variable "ctx" {}

variable "domain" {
  type = string
}

variable "records" {
  type = map(object({
    a = optional(list(object({
      address = string
      ttl     = optional(any, 3600)
      comment = optional(string, "")
    })), [])
    aaaa = optional(list(object({
      address = string
      ttl     = optional(any, 3600)
      comment = optional(string, "")
    })), [])
    cname = optional(list(object({
      cname   = string
      ttl     = optional(any, 3600)
      comment = optional(string, "")
    })), [])
    mx = optional(list(object({
      exchange   = string
      preference = optional(number, 10)
      ttl        = optional(any, 3600)
      comment    = optional(string, "")
    })), [])
    txt = optional(list(object({
      text    = string
      ttl     = optional(any, 3600)
      comment = optional(string, "")
    })), [])
  }))
  description = "DNS records organized by hostname with support for multiple record types"
}
