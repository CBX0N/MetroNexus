resource "cloudflare_dns_record" "cluster_dns_record" {
  name    = var.cloudflare_domain
  zone_id = var.cloudflare_dns_zone_id
  type    = "A"
  content = hcloud_load_balancer.lb_01.ipv4
  ttl     = 60
}

resource "cloudflare_dns_record" "nat_gateway_record" {
  name    = join(".", ["metronexus", var.cloudflare_domain])
  zone_id = var.cloudflare_dns_zone_id
  type    = "A"
  content = hcloud_server.natgw_01.ipv4_address
  ttl     = 60
}
