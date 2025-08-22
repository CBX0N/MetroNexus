# Tell terraform to use the provider and select a version.
terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
    }
  }
  backend "s3" {
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
    region                      = "auto"
  }
}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token    = var.hcloud_token
  endpoint = "https://api.hetzner.cloud/v1"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "kubernetes" {
  client_certificate     = module.k3s_cluster.client-certificate-data
  client_key             = module.k3s_cluster.client-key-data
  cluster_ca_certificate = module.k3s_cluster.certificate-authority-data
  host                   = module.k3s_cluster.server
}

provider "helm" {
  kubernetes = {
    client_certificate     = module.k3s_cluster.client-certificate-data
    client_key             = module.k3s_cluster.client-key-data
    cluster_ca_certificate = module.k3s_cluster.certificate-authority-data
    host                   = module.k3s_cluster.server
  }
}