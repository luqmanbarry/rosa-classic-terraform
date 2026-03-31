terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.5"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.31"
    }

    rhcs = {
      source  = "terraform-redhat/rhcs"
      version = "~> 1.7"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.13"
    }

  }
}

# Export token using the RHCS_TOKEN or TF_VAR_ocm_token environment variable
provider "rhcs" {
  token = var.ocm_token
  url   = var.ocm_url
}

provider "vault" {
  address = var.vault_addr
  token   = var.vault_token
  # auth_login {
  #   path = "auth/approle/login"

  #   parameters = {
  #     role_id   = var.vault_login_approle_role_id
  #     secret_id = var.vault_login_approle_secret_id
  #   }
  # }
}
