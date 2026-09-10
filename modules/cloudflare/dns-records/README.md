# Cloudflare DNS Records Module

This module creates DNS records in Cloudflare with support for multiple record types per hostname.

## Prerequisites

- Cloudflare account with domain management access
- Domain must be added to Cloudflare and active
- Cloudflare API token with Zone:Edit permissions for the target domain

## Provider Configuration

Configure the Cloudflare provider before using this module:

```terraform
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
```

## Complete Example

Here's a complete example showing how to use the module:

```terraform
# Configure the Cloudflare provider
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Use the DNS records module
module "homelab_dns" {
  source = "../../modules/cloudflare/dns-records"

  ctx     = module.ctx
  domain  = "example.com"
  zone_id = var.cloudflare_zone_id
  
  # Set defaults for record types
  a_defaults = {
    proxied = true
    ttl     = 300
  }
  aaaa_defaults = {
    proxied = true
  }
  cname_defaults = {
    ttl = 3600
  }
  mx_defaults = {
    preference = 10
    ttl        = 3600
  }
  txt_defaults = {
    ttl = 1800
  }
  
  records = {
    # Home Assistant - uses defaults (proxied = true, ttl = 300)
    ha = {
      a = [
        { address = "192.168.88.97", comment = "home assistant" }
      ]
    }
    
    # Web services with load balancing - override proxied for some
    web = {
      a = [
        { address = "192.168.1.100", comment = "primary web server" },
        { address = "192.168.1.101", comment = "backup web server", proxied = false, ttl = 600 }
      ]
    }
    
    # WWW alias
    www = {
      cname = [
        { cname = "web.example.com", comment = "www redirect", ttl = 3600 }
      ]
    }
    
    # Mail server
    mail = {
      a = [
        { address = "192.168.1.102", comment = "mail server", ttl = 3600 }
      ]
      mx = [
        { exchange = "mail.example.com", preference = 10, comment = "primary MX", ttl = 3600 }
      ]
      txt = [
        { text = "v=spf1 a mx ~all", comment = "SPF record", ttl = 3600 }
      ]
    }
    
    # Domain verification
    "@" = {
      txt = [
        { text = "google-site-verification=abc123def456", comment = "Google verification" },
        { text = "v=DMARC1; p=quarantine; rua=mailto:dmarc@example.com", comment = "DMARC policy" }
      ]
    }
  }
}

# Access created records
output "web_ips" {
  value = [for record in module.homelab_dns.a_records : record.content if startswith(record.name, "web.")]
}
```

## Usage

### Usage Example with Defaults

Here's how to use the module with defaults as shown in your example:

```terraform
module "dns_records" {
  source = "path/to/modules/cloudflare/dns-records"

  ctx     = module.ctx
  domain  = local.domain
  zone_id = local.cf_zone_id
  
  a_defaults = {
    proxied = true
  }
  
  records = {
    ha = {
      a = [{ 
        address = local.public_ip, 
        comment = "home assistant", 
        ttl     = 600, 
        proxied = true  # This overrides the default
      }]
    }
  }
}
```

In this example:
- All A records will be proxied by default (`proxied = true`)
- The `ha` A record explicitly sets `ttl = 600` and `proxied = true`
- If `proxied` wasn't specified in the record, it would use the default `true`

### Basic Example

```terraform
module "dns_records" {
  source = "path/to/modules/cloudflare/dns-records"

  ctx     = module.ctx
  domain  = "example.com"
  zone_id = var.cloudflare_zone_id
  
  a_defaults = {
    proxied = true
  }
  
  records = {
    web = {
      a = [
        { address = "192.168.1.100", comment = "web server", ttl = 3600 }
      ]
    }
    mail = {
      a = [
        { address = "192.168.1.101", comment = "mail server" }
      ]
      mx = [
        { exchange = "mail.example.com", preference = 10, ttl = 86400 }
      ]
    }
  }
}
```

### Advanced Example with Multiple Record Types

```terraform
module "dns_records" {
  source = "path/to/modules/cloudflare/dns-records"

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
| zone_id | Cloudflare zone ID for the domain | `string` | n/a | yes |
| a_defaults | Default values for A records | `object({...})` | See below | no |
| aaaa_defaults | Default values for AAAA records | `object({...})` | See below | no |
| cname_defaults | Default values for CNAME records | `object({...})` | See below | no |
| mx_defaults | Default values for MX records | `object({...})` | See below | no |
| txt_defaults | Default values for TXT records | `object({...})` | See below | no |
| records | DNS records organized by hostname | `map(object({...}))` | n/a | yes |

### Defaults Structure

The default variables allow you to set default values for each record type, reducing repetition in your configuration:

```terraform
a_defaults = {
  ttl     = optional(number)     # Default TTL for A records (default: 3600)
  comment = optional(string)     # Default comment for A records (default: "")
  proxied = optional(bool)       # Default proxy setting for A records (default: false)
}

aaaa_defaults = {
  ttl     = optional(number)     # Default TTL for AAAA records (default: 3600)
  comment = optional(string)     # Default comment for AAAA records (default: "")
  proxied = optional(bool)       # Default proxy setting for AAAA records (default: false)
}

cname_defaults = {
  ttl     = optional(number)     # Default TTL for CNAME records (default: 3600)
  comment = optional(string)     # Default comment for CNAME records (default: "")
}

mx_defaults = {
  preference = optional(number)  # Default preference for MX records (default: 10)
  ttl        = optional(number)  # Default TTL for MX records (default: 3600)
  comment    = optional(string)  # Default comment for MX records (default: "")
}

txt_defaults = {
  ttl     = optional(number)     # Default TTL for TXT records (default: 3600)
  comment = optional(string)     # Default comment for TXT records (default: "")
}
```

Individual record configurations override defaults. The precedence is:
1. Individual record value (highest priority)
2. Type default value
3. Built-in fallback value (lowest priority)

### Records Structure

Each hostname in the `records` map can contain the following record types as lists. The module automatically generates unique keys based on record content (addresses, targets, etc.) to ensure stable resource identification.

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
| zone_id | Cloudflare zone ID for the domain |

## Migration from Old Format

### Old Usage
```terraform
module "ha" {
  source = "path/to/modules/cloudflare/dns-records"

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
  source = "path/to/modules/cloudflare/dns-records"

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
- **Content-Based Unique Keys**: Records are uniquely identified by their content (address, target, etc.) rather than list position
- **Flexible TTL**: Support for both numeric (seconds) and string formats (e.g., "1h", "1d")
- **Context Integration**: Automatically appends context tags to comments
- **Type Safety**: Full Terraform type validation for all record types
- **Automatic Zone Lookup**: Automatically finds the Cloudflare zone for the specified domain
- **Cloudflare Integration**: Native support for Cloudflare DNS management features

## Unique Key Generation

The module automatically generates unique keys for each record based on content to ensure stable resource identification:

- **A/AAAA records**: `{hostname}-{type}-{sanitized-address}`
- **CNAME records**: `{hostname}-cname-{sanitized-target}`
- **MX records**: `{hostname}-mx-{preference}-{sanitized-exchange}`
- **TXT records**: `{hostname}-txt-{first-8-chars-of-md5-hash}`

This approach ensures that records are uniquely identified by their actual content rather than their position in a list, making the configuration more stable and predictable.

