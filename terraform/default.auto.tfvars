user_home        = "/home/cbxon"
agent_node_count = 2

default_labels = {
  project   = "MetroNexus",
  placement = "ZoneA"
  location  = "Falkenstein"
}

fw_rules = {
  "outbound-icmp" = {
    destination_ips = ["0.0.0.0/0"]
    direction       = "out"
    protocol        = "icmp"
    source_ips      = []
  }
  "outbound-tcp" = {
    destination_ips = ["0.0.0.0/0"]
    direction       = "out"
    protocol        = "tcp"
    source_ips      = []
    port            = "any"
  }
  "outbound-udp" = {
    destination_ips = ["0.0.0.0/0"]
    direction       = "out"
    protocol        = "udp"
    source_ips      = []
    port            = "any"
  }
  "inbound-ssh" = {
    destination_ips = []
    direction       = "in"
    port            = "22"
    protocol        = "tcp"
    source_ips      = ["0.0.0.0/0"]
  }
  "inbound-kubeapi" = {
    destination_ips = []
    direction       = "in"
    port            = "6443"
    protocol        = "tcp"
    source_ips      = ["0.0.0.0/0"]
  }
}