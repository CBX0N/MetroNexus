locals {
  default_labels = {
    project   = "MetroNexus",
    placement = "ZoneA"
    location  = "Falkenstein"
  }
  k3s_labels = merge(local.default_labels, { loadbalancer = true })
  ngw_labels = merge(local.default_labels, { firewall = true })
  k3s_vars   = merge(var.cloud_init_networking, var.cloud_init_user, var.cloud_init_smb_share, var.cloud_init_k3s, { cluster_token = random_string.cluster_join_token.result })
  ngw_vars   = merge(var.cloud_init_networking, var.cloud_init_user)
}