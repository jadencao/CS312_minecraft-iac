# ----------------------------------------------------------------------------
# provider.tf — Tells Terraform WHICH plugins/providers it needs and where
# we are deploying. Terraform itself is just an engine; providers are the
# plugins that know how to talk to specific services (AWS, TLS, local files).
# ----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"   # aws
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"   # tls
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"   # local
    }
  }
}

provider "aws" {
  region = var.aws_region
}