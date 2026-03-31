terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.31"
    }

    rhcs = {
      source  = "terraform-redhat/rhcs"
      version = "~> 1.7"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.5"
    }
  }
}

provider "rhcs" {
  token = var.ocm_token
  url   = try(var.stack.ocm_url, "https://api.openshift.com")
}

provider "vault" {
  address = var.vault_addr
  token   = var.vault_token
}

provider "kubernetes" {
  alias       = "managed_cluster"
  config_path = var.managed_cluster_kubeconfig_filename
  insecure    = true
}

provider "kubernetes" {
  alias       = "acmhub_cluster"
  config_path = var.acmhub_kubeconfig_filename
  insecure    = true
}
