locals {
  name_prefix = "antman"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "2.7.1"
    }
  }
}

# Configure the AWS Provider (Archive doesn't require configuration so no need for that block here)
provider "aws" {
  region = var.region
}
