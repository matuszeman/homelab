variable "ctx" {}
variable "disabled" {
    default = false
}

variable "interface" {
  type = string
}

variable "lease_time" {
  type = string
  default = "30m"
}

variable "address" {}

variable "address_pool" {
  type = object({
    cidr = optional(string)
    range = optional(object({
      start = string
      end = string
    }))
  })
}
