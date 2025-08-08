resource "hcloud_load_balancer" "lb_01" {
  name               = "fsn1-lb-01"
  load_balancer_type = "lb11"
  location           = "fsn1"
  labels             = local.default_labels
}

resource "hcloud_load_balancer_network" "lb_01_network" {
  load_balancer_id        = hcloud_load_balancer.lb_01.id
  subnet_id               = hcloud_network_subnet.snet_01.id
  enable_public_interface = true
}

resource "hcloud_load_balancer_target" "load_balancer_target" {
  type             = "label_selector"
  load_balancer_id = hcloud_load_balancer.lb_01.id
  label_selector   = "loadbalancer"
  use_private_ip   = true
  depends_on       = [hcloud_load_balancer_network.lb_01_network]
}