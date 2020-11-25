variable "secretsanta_lambda_name" {
  default = "SecretSantaLambda"
}

variable "secretsanta_lambda_version" {
  default = "v0.1.0"
}

variable "gmail_token" {
  default = ""
  description = "Gmail user key"
}

# From other modules
variable "lambda_deploy_bucket_name" {}
