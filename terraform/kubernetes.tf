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
    "identity" = file("~/.ssh/flux")
  }
}

resource "kubernetes_manifest" "flux_git_repository" {
  depends_on = [helm_release.flux, kubernetes_secret.flux_ssh_key]
  manifest = {
    apiVersion = "source.toolkit.fluxcd.io/v1"
    kind       = "GitRepository"
    metadata = {
      name      = "flux-system"
      namespace = "flux-system"
    }
    spec = {
      interval = "1m0s"
      ref = {
        branch = "main"
      }
      secretRef = {
        name = "flux-system"
      }
      url = "ssh://git@github.com/cbx0n/MetroNexus"
    }
  }
}

resource "kubernetes_manifest" "flux_kustomization" {
  depends_on = [kubernetes_manifest.flux_git_repository]
  manifest = {
    apiVersion = "kustomize.toolkit.fluxcd.io/v1"
    kind       = "Kustomization"
    metadata = {
      name      = "kustomizations"
      namespace = "flux-system"
    }
    spec = {
      interval = "10m0s"
      path     = "./flux/kustomizations"
      prune    = true
      sourceRef = {
        kind = "GitRepository"
        name = "flux-system"
      }
    }
  }
}