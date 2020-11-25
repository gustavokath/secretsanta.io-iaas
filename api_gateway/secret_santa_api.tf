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

resource "aws_api_gateway_method" "options_method" {
   rest_api_id   = aws_api_gateway_rest_api.secret_santa_rest_api.id
   resource_id   = aws_api_gateway_resource.secret_santa_api_resource.id
   http_method   = "OPTIONS"
   authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_200" {
   rest_api_id   = aws_api_gateway_rest_api.secret_santa_rest_api.id
   resource_id   = aws_api_gateway_resource.secret_santa_api_resource.id
   http_method   = aws_api_gateway_method.options_method.http_method
   status_code   = "200"
   response_models = {
      "application/json" = "Empty"
   }
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Origin" = true
    }
    depends_on = [aws_api_gateway_method.options_method]
}
resource "aws_api_gateway_method_response" "options_404" {
   rest_api_id   = aws_api_gateway_rest_api.secret_santa_rest_api.id
   resource_id   = aws_api_gateway_resource.secret_santa_api_resource.id
   http_method   = aws_api_gateway_method.options_method.http_method
   status_code   = "404"
   response_models = {
      "application/json" = "Empty"
   }
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Origin" = true
    }
    depends_on = [aws_api_gateway_method.options_method]
}

resource "aws_api_gateway_integration" "options_integration" {
   rest_api_id   = aws_api_gateway_rest_api.secret_santa_rest_api.id
   resource_id   = aws_api_gateway_resource.secret_santa_api_resource.id
   http_method   = aws_api_gateway_method.options_method.http_method
   type          = "MOCK"
    request_templates = {
    "application/json" = jsonencode(
      {
        statusCode = 200
      }
    )
  }
   depends_on = [aws_api_gateway_method.options_method]
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
   rest_api_id   = aws_api_gateway_rest_api.secret_santa_rest_api.id
   resource_id   = aws_api_gateway_resource.secret_santa_api_resource.id
   http_method   = aws_api_gateway_method.options_method.http_method
   status_code   = aws_api_gateway_method_response.options_200.status_code
   response_parameters = {
      "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,X-Amz-Security-Token,Authorization,X-Api-Key,X-Requested-With,Accept,Access-Control-Allow-Methods,Access-Control-Allow-Origin,Access-Control-Allow-Headers'",
      "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'",
      "method.response.header.Access-Control-Allow-Origin" = "'*'"
   }
    depends_on = [aws_api_gateway_method_response.options_200]
}

resource "aws_api_gateway_integration_response" "options_integration_404_response" {
   rest_api_id   = aws_api_gateway_rest_api.secret_santa_rest_api.id
   resource_id   = aws_api_gateway_resource.secret_santa_api_resource.id
   http_method   = aws_api_gateway_method.options_method.http_method
   status_code   = aws_api_gateway_method_response.options_404.status_code
   selection_pattern = ".*\"status\":404.*"
   response_parameters = {
      "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,X-Amz-Security-Token,Authorization,X-Api-Key,X-Requested-With,Accept,Access-Control-Allow-Methods,Access-Control-Allow-Origin,Access-Control-Allow-Headers'",
      "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'",
      "method.response.header.Access-Control-Allow-Origin" = "'*'"
   }
    depends_on = [aws_api_gateway_method_response.options_404]
}

