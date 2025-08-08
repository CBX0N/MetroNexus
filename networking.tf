resource "hcloud_network" "net_01" {
  name     = "net-01"
  ip_range = "10.0.0.0/16"
  labels   = local.default_labels
}

resource "hcloud_network_subnet" "snet_01" {
  network_id   = hcloud_network.net_01.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.0.0/24"
}

resource "hcloud_network_route" "nat_gateway" {
  network_id  = hcloud_network.net_01.id
  destination = "0.0.0.0/0"
  gateway     = "10.0.0.3"
  depends_on  = [hcloud_server.natgw_01]
}

resource "hcloud_firewall" "natgw_fw01" {
  name = "natgw-fw01"
  rule {
    destination_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
    direction  = "out"
    protocol   = "icmp"
    source_ips = []
  }
  rule {
    destination_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
    direction  = "out"
    port       = "any"
    protocol   = "tcp"
    source_ips = []

  }
  rule {
    destination_ips = [
      "0.0.0.0/0",
      "::/0",
    ]
    direction  = "out"
    port       = "any"
    protocol   = "udp"
    source_ips = []

  }
  rule {
    destination_ips = []
    direction       = "in"
    port            = "22"
    protocol        = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]

  }
  rule {
    destination_ips = []
    direction       = "in"
    port            = "2222"
    protocol        = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]

  }
  rule {
    destination_ips = []
    direction       = "in"
    port            = "6443"
    protocol        = "tcp"
    source_ips = [
      "0.0.0.0/0",
      "::/0",
    ]

  }
  apply_to {
    label_selector = "firewall"
  }
  labels = local.default_labels
}