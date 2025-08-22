resource "cloudflare_dns_record" "server_record" {
  name    = join(".", ["metronexus", var.cloudflare_domain])
  zone_id = var.cloudflare_dns_zone_id
  type    = "A"
  content = module.k3s_cluster.public_ipv4
  ttl     = 60
}

data "hcloud_load_balancers" "loadbalancers" {}

locals {
  loadbalancers = contains(data.hcloud_load_balancers.loadbalancers.load_balancers[*].name, "fsn-lb-01")
}

resource "cloudflare_dns_record" "cluster_record" {
  count   = local.loadbalancers ? 1 : 0
  name    = join(".", ["cluster", var.cloudflare_domain])
  zone_id = var.cloudflare_dns_zone_id
  type    = "A"
  content = one([
    for lb in data.hcloud_load_balancers.loadbalancers.load_balancers : lb.ipv4
    if lb.name == "fsn-lb-01"
  ])
  ttl = 60
}