resource "routeros_interface_list" "lan" {
  name = "LAN"
  comment = "TF"
}

resource "routeros_interface_list" "wan" {
  name = "WAN"
  comment = "TF"
}
