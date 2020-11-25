variable "region"{
  default = "sa-east-1"
}

variable "region_us"{
  default = "us-east-1"
}

variable "website_bucket_name" {
  default = "secretsanta.gkath.com"
}

variable "lambda_deploy_bucket_name" {
  default = "secretsanta-lambda-deploy-bucket"
}

variable "gmail_token" {
  default = ""
  description = "Gmail user key"
}