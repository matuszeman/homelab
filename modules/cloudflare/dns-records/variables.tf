variable "ctx" {}

variable "domain" {
  type = string
}

variable "zone_id" {}

variable "a_defaults" {
  type = object({
    ttl     = optional(number)
    comment = optional(string)
    proxied = optional(bool)
  })
  default = {
    ttl     = 3600
    comment = ""
    proxied = false
  }
  description = "Default values for A records"
}

variable "aaaa_defaults" {
  type = object({
    ttl     = optional(number)
    comment = optional(string)
    proxied = optional(bool)
  })
  default = {
    ttl     = 3600
    comment = ""
    proxied = false
  }
  description = "Default values for AAAA records"
}

variable "cname_defaults" {
  type = object({
    ttl     = optional(number)
    comment = optional(string)
  })
  default = {
    ttl     = 3600
    comment = ""
  }
  description = "Default values for CNAME records"
}

variable "mx_defaults" {
  type = object({
    preference = optional(number)
    ttl        = optional(number)
    comment    = optional(string)
  })
  default = {
    preference = 10
    ttl        = 3600
    comment    = ""
  }
  description = "Default values for MX records"
}

variable "txt_defaults" {
  type = object({
    ttl     = optional(number)
    comment = optional(string)
  })
  default = {
    ttl     = 3600
    comment = ""
  }
  description = "Default values for TXT records"
}

variable "records" {
  type = map(object({
    a = optional(list(object({
      address = string
      ttl     = optional(number)
      comment = optional(string)
      proxied = optional(bool)
    })), [])
    aaaa = optional(list(object({
      address = string
      ttl     = optional(number)
      comment = optional(string)
      proxied = optional(bool)
    })), [])
    cname = optional(list(object({
      cname   = string
      ttl     = optional(number)
      comment = optional(string)
    })), [])
    mx = optional(list(object({
      exchange   = string
      preference = optional(number)
      ttl        = optional(number)
      comment    = optional(string)
    })), [])
    txt = optional(list(object({
      text    = string
      ttl     = optional(number)
      comment = optional(string)
    })), [])
  }))
  description = "DNS records organized by hostname with support for multiple record types"
}
