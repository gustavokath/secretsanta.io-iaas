resource "aws_lambda_function" "secret_santa_lambda" {
  function_name = var.secretsanta_lambda_name

  s3_bucket = var.lambda_deploy_bucket_name
  s3_key = "${var.secretsanta_lambda_version}/secretsanta.zip"

  handler = "src/main.SecretSanta.run"
  runtime = "ruby2.7"
  timeout = 120

  role = aws_iam_role.secret_santa_lambda_role.arn

  depends_on = [
    aws_iam_role_policy_attachment.secret_santa_lambda_logging_policy_attach,
    aws_cloudwatch_log_group.secretsanta_lambda_loggroup
  ]

  environment {
    variables = {
      GMAIL_TOKEN = var.gmail_token
    }
  }
}

resource "aws_iam_role" "secret_santa_lambda_role" {
  name = "secret_santa_lambda_role"

  assume_role_policy = "${data.aws_iam_policy_document.secret_santa_lambda_assume_role_policy.json}"
}

data "aws_iam_policy_document" "secret_santa_lambda_assume_role_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "secret_santa_lambda_logging_policy_attach" {
  role       = aws_iam_role.secret_santa_lambda_role.name
  policy_arn = aws_iam_policy.secret_santa_lambda_logging.arn
}

resource "aws_iam_policy" "secret_santa_lambda_logging" {
  name        = "secret_santa_lambda_logging"
  path        = "/"
  description = "IAM policy for logging from Secret Santa lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "secretsanta_lambda_loggroup" {
  name              = "/aws/lambda/${var.secretsanta_lambda_name}"
  retention_in_days = 14
}

output "secret_santa_lambda_invoke_arn" {
  value = aws_lambda_function.secret_santa_lambda.invoke_arn
}

output "secret_santa_lambda_name" {
  value = aws_lambda_function.secret_santa_lambda.function_name
}
