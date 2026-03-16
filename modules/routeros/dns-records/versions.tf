terraform {
  required_version = ">= 1.9.0"

  required_providers {
    routeros = {
      source  = "terraform-routeros/routeros"
      version = ">= 1.80"
    }
  }
}