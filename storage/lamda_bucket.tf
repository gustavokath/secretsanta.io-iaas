resource "aws_s3_bucket" "secretsanta-lambda-bucket" {
  bucket = var.lambda_deploy_bucket_name
  acl    = "private"
}