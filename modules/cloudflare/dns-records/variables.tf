variable "ctx" {}

variable "domain" {
  type = string
}

variable "zone_id" {}
variable "record_tags" {
  type = bool
  default = false
}
variable "comment_tags" {
  type = bool
  default = true
}

variable "defaults" {
  type = object({
    a = optional(object({
      ttl     = optional(number)
      comment = optional(string)
      proxied = optional(bool)
    }), { ttl = 3600, comment = "", proxied = false })
    aaaa = optional(object({
      ttl     = optional(number)
      comment = optional(string)
      proxied = optional(bool)
    }), { ttl = 3600, comment = "", proxied = false })
    cname = optional(object({
      ttl     = optional(number)
      comment = optional(string)
    }), { ttl = 3600, comment = "" })
    mx = optional(object({
      preference = optional(number)
      ttl        = optional(number)
      comment    = optional(string)
    }), { preference = 10, ttl = 3600, comment = "" })
    txt = optional(object({
      ttl     = optional(number)
      comment = optional(string)
    }), { ttl = 3600, comment = "" })
  })
  default     = {}
  description = "Default values for each record type"
}

variable "records" {
  type = map(object({
    a = optional(list(object({
      value   = string
      ttl     = optional(number)
      comment = optional(string)
      proxied = optional(bool)
    })), [])
    aaaa = optional(list(object({
      value   = string
      ttl     = optional(number)
      comment = optional(string)
      proxied = optional(bool)
    })), [])
    cname = optional(list(object({
      value   = string
      ttl     = optional(number)
      comment = optional(string)
    })), [])
    mx = optional(list(object({
      value      = string
      preference = optional(number)
      ttl        = optional(number)
      comment    = optional(string)
    })), [])
    txt = optional(list(object({
      value   = string
      ttl     = optional(number)
      comment = optional(string)
    })), [])
  }))
  description = "DNS records organized by hostname with support for multiple record types"
}
