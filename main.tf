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
      name = "photo-glacier-iaas"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

provider "aws" {
  alias = "us"
  region = var.region_us
}

module "s3"{
  source = "./storage"
}

module "auth" {
  source = "./auth"
  providers = {
    aws = aws.us
  }

  photos_bucket_name = module.s3.photo_users_photos_bucket_name
}