# Set the variable value in *.tfvars file
# or using the -var="hcloud_token=..." CLI option
variable "hcloud_token" {
  sensitive = true
}

variable "cloudflare_api_token" {
  sensitive = true
}

variable "cloudflare_dns_zone_id" {
  sensitive = true
}

variable "cloudflare_domain" {
  type = string
}

variable "cloud_init_user" {
  type = object({
    username        = string
    hashed_password = string
    ssh_key         = string
  })
}

variable "cloud_init_smb_share" {
  type = object({
    smb_username = string
    smb_password = string
    smb_path     = string
  })
  sensitive = true
}

variable "cloud_init_k3s" {
  type = object({
    k3s_url = string
    k3s_san = string
  })
}

variable "cloud_init_networking" {
  type = object({
    gateway      = string
    network_cidr = string
  })
  default = {
    gateway      = "10.0.0.1"
    network_cidr = "10.0.0.0/16"
  }
}

variable "agent_node_count" {
  type    = number
  default = 0
}