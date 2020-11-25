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
  lambda_deploy_bucket_name = var.lambda_deploy_bucket_name
}

module "identity"{
  source = "./identity"
  website_bucket_name = var.website_bucket_name
  lambda_deploy_bucket_name = var.lambda_deploy_bucket_name
}

module "lambda"{
  source = "./lambda"
  lambda_deploy_bucket_name = var.lambda_deploy_bucket_name
  gmail_token = var.gmail_token
}

module "api_gateway"{
  source = "./api_gateway"
  website_bucket_name = var.website_bucket_name
  lambda_deploy_bucket_name = var.lambda_deploy_bucket_name
  secret_santa_lambda_invoke_arn = module.lambda.secret_santa_lambda_invoke_arn
  secret_santa_lambda_name = module.lambda.secret_santa_lambda_name
}