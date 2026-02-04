# RouterOS DNS Records Module

This module creates DNS records in RouterOS with support for multiple record types per hostname.

## Usage

### Basic Example

```terraform
module "dns_records" {
  source = "path/to/modules/routeros/dns-records"

  ctx    = module.ctx
  domain = "example.com"
  records = {
    web = {
      a = [
        { address = "192.168.1.100", comment = "web server", ttl = "1h" }
      ]
    }
    mail = {
      a = [
        { address = "192.168.1.101", comment = "mail server" }
      ]
      mx = [
        { exchange = "mail.example.com", preference = 10, ttl = "1d" }
      ]
    }
  }
}
```

### Advanced Example with Multiple Record Types

```terraform
module "dns_records" {
  source = "path/to/modules/routeros/dns-records"

  ctx    = module.ctx
  domain = "example.com"
  records = {
    web = {
      a = [
        { address = "192.168.1.100", comment = "primary web server", ttl = "1h" },
        { address = "192.168.1.101", comment = "backup web server", ttl = "1h" }
      ]
      aaaa = [
        { address = "2001:db8::1", comment = "IPv6 web server", ttl = "1h" }
      ]
    }
    www = {
      cname = [
        { cname = "web.example.com", comment = "www alias", ttl = "1d" }
      ]
    }
    mail = {
      a = [
        { address = "192.168.1.102", comment = "mail server" }
      ]
      mx = [
        { exchange = "mail.example.com", preference = 10, ttl = "1d" }
      ]
      txt = [
        { text = "v=spf1 a mx ~all", comment = "SPF record", ttl = "1h" }
      ]
    }
    verification = {
      txt = [
        { text = "google-site-verification=abc123", comment = "Google verification" },
        { text = "v=DMARC1; p=quarantine", comment = "DMARC policy" }
      ]
    }
  }
}
```

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ctx | Context object | `any` | n/a | yes |
| domain | Domain name for the records | `string` | n/a | yes |
| records | DNS records organized by hostname | `map(object({...}))` | n/a | yes |

### Records Structure

Each hostname in the `records` map can contain the following record types:

#### A Records
```terraform
a = [
  {
    address = string
    ttl     = optional(any, 3600)    # Can be number (seconds) or string (e.g., "1h", "1d")
    comment = optional(string, "")
  }
]
```

#### AAAA Records
```terraform
aaaa = [
  {
    address = string                 # IPv6 address
    ttl     = optional(any, 3600)
    comment = optional(string, "")
  }
]
```

#### CNAME Records
```terraform
cname = [
  {
    cname   = string                 # Target hostname
    ttl     = optional(any, 3600)
    comment = optional(string, "")
  }
]
```

#### MX Records
```terraform
mx = [
  {
    exchange   = string              # Mail server hostname
    preference = optional(number, 10)
    ttl        = optional(any, 3600)
    comment    = optional(string, "")
  }
]
```

#### TXT Records
```terraform
txt = [
  {
    text    = string                 # TXT record content
    ttl     = optional(any, 3600)
    comment = optional(string, "")
  }
]
```

## Outputs

| Name | Description |
|------|-------------|
| a_records | Created A records |
| aaaa_records | Created AAAA records |
| cname_records | Created CNAME records |
| mx_records | Created MX records |
| txt_records | Created TXT records |
| all_records | All created DNS records organized by type |

## Migration from Old Format

### Old Usage
```terraform
module "ha" {
  source = "path/to/modules/routeros/dns-records"

  ctx = module.ctx
  domain = "matuszeman.dev"
  a = {
    ha = { address = "192.168.88.97", comment = "home assistant", ttl = "1d" }
  }
}
```

### New Usage
```terraform
module "ha" {
  source = "path/to/modules/routeros/dns-records"

  ctx = module.ctx
  domain = "matuszeman.dev"
  records = {
    ha = {
      a = [{ address = "192.168.88.97", comment = "home assistant", ttl = "1d" }]
    }
  }
}
```

## Features

- **Multiple Record Types**: Support for A, AAAA, CNAME, MX, and TXT records
- **Multiple Records per Hostname**: Each hostname can have multiple records of the same type
- **Flexible TTL**: Support for both numeric (seconds) and string formats (e.g., "1h", "1d")
- **Context Integration**: Automatically appends context tags to comments
- **Type Safety**: Full Terraform type validation for all record types
