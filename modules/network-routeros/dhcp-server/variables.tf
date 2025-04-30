variable "interface" {
  type = string
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