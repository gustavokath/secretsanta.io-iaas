variable "secretsanta_lambda_name" {
  default = "SecretSantaLambda"
}

variable "secretsanta_lambda_version" {
  default = "v0.1.0"
}

# From other modules
variable "lambda_deploy_bucket_name" {}

variable "gmail_token" {}

variable "aws_region" {}


