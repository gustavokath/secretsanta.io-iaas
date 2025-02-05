resource "aws_iam_group" "group-ci" {
  name = "ContinousIntegration"
}

resource "aws_iam_policy" "ci-website-s3-deploy" {
  name        = "ci-website-s3-deploy"
  description = "Permissions for CI deploy website to S3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:DeleteObject",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${var.website_bucket_name}",
        "arn:aws:s3:::${var.website_bucket_name}/*",
        "arn:aws:s3:::${var.lambda_deploy_bucket_name}",
        "arn:aws:s3:::${var.lambda_deploy_bucket_name}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "group-ci-s3-deploy-attach" {
  group      = aws_iam_group.group-ci.name
  policy_arn = aws_iam_policy.ci-website-s3-deploy.arn
}

resource "aws_iam_policy" "ci-lmbda-update" {
  name        = "ci-lambda-update"
  description = "Permissions for CI update lambda code"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "lambda:UpdateFunctionCode"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:lambda:${var.aws_region}:030606588401:function:${var.secret_santa_lambda_name}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "group-ci-lambda-update-attach" {
  group      = aws_iam_group.group-ci.name
  policy_arn = aws_iam_policy.ci-lmbda-update.arn
}

resource "aws_iam_user" "ci-user" {
  name = "ci"
}

resource "aws_iam_user_group_membership" "example2" {
  user = aws_iam_user.ci-user.name

  groups = [
    aws_iam_group.group-ci.name,
  ]
}