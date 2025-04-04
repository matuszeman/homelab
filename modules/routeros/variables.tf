variable "networks" {
  type = map(object({
    vlan = optional(number)
  }))
}
variable "bridge" {
  type = object({
    ports = map(object({
      vlan = optional(string, "1")
      #interface = string
    }))
  })
}
variable "wan" {
  type = object({
    interface = string
  })
}

variable "vlan_filtering" {
  type = bool
}
variable "vlans" {
  type = map(object({
    #vlan = number
    #network = string
    untagged = list(string)
    tagged   = list(string)
  }))
}