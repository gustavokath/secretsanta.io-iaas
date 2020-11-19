resource "aws_s3_bucket" "secretsanta-website" {
  bucket = "secretsanta.gkath.com"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_policy" "secretsanta-website-policy" {
  bucket = aws_s3_bucket.secretsanta-website.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.secretsanta-website.id}/*"
    }
  ]
}
POLICY
}