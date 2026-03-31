terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
      configuration_aliases = [
        kubernetes.managed_cluster,
        kubernetes.acmhub_cluster,
      ]
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.7"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.13"
    }
  }
}
