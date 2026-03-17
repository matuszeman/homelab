variable "ctx" {}

variable "zone_name" {
  type        = string
  description = "DNS zone root (e.g. \"example.com\")"
}

variable "domain" {
  type        = string
  default     = null
  description = "Optional subdomain scope. When set, all records are placed under $${domain}.$${zone_name} and @ resolves to that base."
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

variable "placeholders" {
  type        = map(string)
  default     = {}
  description = "Map of placeholder keys to replacement values. Use $${KEY} in record values to reference (e.g. placeholders = { PUBLIC_IP = \"1.2.3.4\" } resolves $${PUBLIC_IP} in values)."
}

variable "records" {
  type = map(object({
    a = optional(list(object({
      value   = string
      ttl     = optional(number)
      comment = optional(string)
    })), [])
    aaaa = optional(list(object({
      value   = string
      ttl     = optional(number)
      comment = optional(string)
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
  default     = {}
  description = "DNS records organized by hostname with support for multiple record types"
}
