variable "pool" {
  type = object({
    cidr = optional(string)
    range = optional(object({
      start = string
      end = string
    }))
  })
}

output "range" {
  value = var.pool.range != null ? var.pool.range : {
    start = cidrhost(var.pool.cidr, 0)
    end = cidrhost(var.pool.cidr, -1)
  }
}