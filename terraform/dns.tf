resource "cloudflare_dns_record" "server_record" {
  name    = join(".", ["metronexus", var.cloudflare_domain])
  zone_id = var.cloudflare_dns_zone_id
  type    = "A"
  content = module.k3s_cluster.public_ipv4
  ttl     = 60
}
