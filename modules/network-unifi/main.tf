data "unifi_ap_group" "default" {
}

data "unifi_user_group" "default" {
}

resource "unifi_network" "this" {
  name    = var.network.name
  purpose = "corporate"

  subnet       = var.network.cidr
  domain_name = var.network.domain
  dhcp_enabled = var.network.dhcp_server != null
  dhcp_dns = var.network.nameservers
  dhcp_start = var.network.dhcp_server != null ? var.network.address_pools["dhcp"].range.start : null
  dhcp_stop = var.network.dhcp_server != null ? var.network.address_pools["dhcp"].range.end : null
  dhcp_v6_enabled = false

  vlan_id      = var.vlan_id

  # I was getting error:
  # Error: not found
  ipv6_pd_start                          = "::2"
  ipv6_pd_stop                           = "::7d1"
  ipv6_ra_priority                       = "high"
  dhcp_v6_start                          = "::2"
  dhcp_v6_stop                           = "::7d1"
}

# https://registry.terraform.io/providers/paultyng/unifi/latest/docs/resources/wlan
resource "unifi_wlan" "this" {
  count = var.wifi_ssid == null ? 0 : 1
  name       = var.wifi_ssid
  hide_ssid  = var.wifi_hide_ssid
  passphrase = var.wifi_passphrase
  security   = "wpapsk"

  # enable WPA2/WPA3 support
  wpa3_support    = true
  wpa3_transition = true
  pmf_mode        = "optional"

  wlan_band = var.wifi_2ghz != null && var.wifi_5ghz != null ? "both" : var.wifi_2ghz == null ? "5g" : "2g"
  # Band Steering
  no2ghz_oui = var.wifi_2ghz != null && var.wifi_5ghz != null

  network_id    = unifi_network.this.id
  ap_group_ids  = [data.unifi_ap_group.default.id]
  user_group_id = data.unifi_user_group.default.id
}
