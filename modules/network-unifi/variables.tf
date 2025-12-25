variable "vlan_id" {
  type = number
  default = null
}

variable "wifi_ssid" {
  default = null
}

variable "wifi_hide_ssid" {
  type    = bool
  default = false
}

variable "wifi_2ghz" {
  type = object({
    #channel = optional(number)
  })
  default = null
}

variable "wifi_5ghz" {
  type = object({
  })
  default = null
}


variable "wifi_passphrase" {}
