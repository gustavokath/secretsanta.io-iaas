terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "remote" {
    hostname = "app.terraform.io"
    organization = "PhotoGlacier"

    workspaces {
      name = "secretsantaio-iaas"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}