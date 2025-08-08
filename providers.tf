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