resource "hcloud_placement_group" "placement_a" {
  name   = "placement-A"
  type   = "spread"
  labels = local.default_labels
}

resource "hcloud_server" "natgw_01" {
  name        = "fsn1-ngw-01"
  image       = "ubuntu-24.04"
  server_type = "cax11"
  location    = "fsn1"
  network {
    network_id = hcloud_network.net_01.id
    ip         = "10.0.0.3"
  }
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  user_data                = templatefile("./cloud-init/nat-gateway.tfpl", local.ngw_vars)
  placement_group_id       = hcloud_placement_group.placement_a.id
  labels                   = local.ngw_labels
  shutdown_before_deletion = true
}

resource "random_string" "cluster_join_token" {
  numeric = false
  special = false
  upper   = false
  length  = 25
}

resource "hcloud_server" "server_node" {
  name        = "fsn1-k3s-01"
  image       = "ubuntu-24.04"
  server_type = "cax11"
  location    = "fsn1"
  network {
    network_id = hcloud_network.net_01.id
    ip         = "10.0.0.4"
  }
  public_net {
    ipv4_enabled = false
    ipv6_enabled = false
  }
  user_data                = templatefile("./cloud-init/server-node.tfpl", local.k3s_vars)
  placement_group_id       = hcloud_placement_group.placement_a.id
  shutdown_before_deletion = true
  labels                   = merge(local.k3s_labels)
  lifecycle {
    ignore_changes = [network]
  }
  depends_on = [hcloud_server.natgw_01]
}

resource "random_string" "agent_name" {
  count   = var.agent_node_count
  numeric = false
  special = false
  upper   = false
  length  = 5
}

resource "hcloud_server" "agent_nodes" {
  count       = var.agent_node_count
  name        = join("-", ["fsn1-k3a", random_string.agent_name[count.index].result])
  image       = "ubuntu-24.04"
  server_type = "cax11"
  location    = "fsn1"
  network {
    network_id = hcloud_network.net_01.id
  }
  public_net {
    ipv4_enabled = false
    ipv6_enabled = false
  }
  user_data                = templatefile("./cloud-init/agent-nodes.tfpl", local.k3s_vars)
  placement_group_id       = hcloud_placement_group.placement_a.id
  shutdown_before_deletion = true
  depends_on               = [hcloud_server.server_node]
  labels                   = local.k3s_labels
  lifecycle {
    ignore_changes = [network]
  }
}
