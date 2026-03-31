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

    time = {
      source  = "hashicorp/time"
      version = "~> 0.13"
    }
  }
}
