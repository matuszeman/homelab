variable "member_id" {}

variable "zerotier_network" {
  type = object({
    id = string
    network = object({
      name = string
      gateway = string
    })
  })
}