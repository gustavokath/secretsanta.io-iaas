terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

module "s3"{
  source = "./storage"
  website_bucket_name = var.website_bucket_name
}

module "identity"{
  source = "./identity"
  website_bucket_name = var.website_bucket_name
}