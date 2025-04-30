terraform {
  required_providers {
    routeros = {
      source = "terraform-routeros/routeros"
      version = ">= 1.81"
    }
    zerotier = {
      source = "zerotier/zerotier"
      version = ">= 1.6.0"
    }
  }
}