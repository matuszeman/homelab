variable "hostname" {
  type = string
}

variable "write_files" {
  type = list(object({
    content: string
    path: string
    permissions: optional(string)
    owner: optional(string)
  }))
  default = []
}

variable "nics" {
  type = list(object({
    name: string
    mac: string
    static_ip = optional(string)
    network: object({
      nameservers = set(string)
      gateway = string
      cidr = string
    })
  }))
}

variable "user" {
  type = object({
    name = string
    password = string
    ssh_authorized_key = string
  })
}

variable "runcmd" {
  type = string
}