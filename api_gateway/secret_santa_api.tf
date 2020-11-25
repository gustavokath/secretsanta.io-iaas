resource "aws_api_gateway_rest_api" "secret_santa_rest_api" {
  name = "SecretSantaRestAPI"
}

resource "aws_api_gateway_resource" "secret_santa_api_resource" {
   rest_api_id = aws_api_gateway_rest_api.secret_santa_rest_api.id
   parent_id   = aws_api_gateway_rest_api.secret_santa_rest_api.root_resource_id
   path_part   = "secret_santa"
}

resource "aws_api_gateway_method" "secret_santa_api_method" {
   rest_api_id   = aws_api_gateway_rest_api.secret_santa_rest_api.id
   resource_id   = aws_api_gateway_resource.secret_santa_api_resource.id
   http_method   = "POST"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "secret_santa_api_integration" {
   rest_api_id = aws_api_gateway_rest_api.secret_santa_rest_api.id
   resource_id = aws_api_gateway_method.secret_santa_api_method.resource_id
   http_method = aws_api_gateway_method.secret_santa_api_method.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = var.secret_santa_lambda_invoke_arn
}

resource "aws_api_gateway_deployment" "secret_santa_api_deployment" {
   depends_on = [
     aws_api_gateway_integration.secret_santa_api_integration,
   ]

   rest_api_id = aws_api_gateway_rest_api.secret_santa_rest_api.id
   stage_name  = "prod"
}

resource "aws_lambda_permission" "secret_santa_api_lambda_permission" {
   statement_id  = "AllowAPIGatewayInvokeSecretSantaLambda"
   action        = "lambda:InvokeFunction"
   function_name = var.secret_santa_lambda_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.secret_santa_rest_api.execution_arn}/*/*"
}