resource "routeros_interface_list" "lan" {
  name    = "LAN"
  comment = format(local.comment_format, "")
}

resource "routeros_interface_list" "wan" {
  name    = "WAN"
  comment = format(local.comment_format, "")
}
