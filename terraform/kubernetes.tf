resource "kubernetes_secret" "hcloud_token" {
  depends_on = [local_file.kubeconfig]
  metadata {
    name = "hcloud"
  }
  data = {
    "token"   = var.hcloud_token
    "network" = "net-01"
  }
}

resource "kubernetes_secret" "flux_ssh_key" {
  depends_on = [helm_release.flux]
  metadata {
    name      = "flux-system"
    namespace = "flux-system"
  }
  data = {
    "identity"     = file("~/.ssh/flux")
    "identity.pub" = file("~/.ssh/flux.pub")
    "known_hosts"  = "github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl"
  }
}

resource "kubernetes_secret" "cloudflare_api_key" {
  metadata {
    name      = "cloudflare-api-token-secret"
    namespace = "flux-system"
  }
  data = {
    api-token = var.cloudflare_api_token
  }
}