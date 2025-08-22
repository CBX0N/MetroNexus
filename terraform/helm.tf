resource "helm_release" "hccm" {
  depends_on = [kubernetes_secret.hcloud_token]
  name       = "hccm"
  repository = "https://charts.hetzner.cloud"
  chart      = "hcloud-cloud-controller-manager"
  set = [
    {
      name  = "networking.enabled"
      value = true
    },
    {
      name  = "networking.clusterCIDR"
      value = "10.42.0.0/16"
  }]
}

resource "helm_release" "flux" {
  depends_on       = [helm_release.hccm]
  name             = "flux"
  namespace        = "flux-system"
  repository       = "https://fluxcd-community.github.io/helm-charts"
  chart            = "flux2"
  create_namespace = true
}