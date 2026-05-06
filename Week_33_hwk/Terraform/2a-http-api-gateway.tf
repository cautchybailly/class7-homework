#HTTP API Gateway

resource "aws_apigatewayv2_api" "http_api_gateway" {
  name          = "${local.name_prefix}-http-python-api"
  protocol_type    = "HTTP"
}

# Integrations

resource "aws_apigatewayv2_integration" "python" {
  api_id           = aws_apigatewayv2_api.http_api_gateway.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.python.invoke_arn
}

resource "aws_apigatewayv2_integration" "node" {
  api_id           = aws_apigatewayv2_api.http_api_gateway.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.node.invoke_arn
}

# Routes

resource "aws_apigatewayv2_route" "python" {
  api_id    = aws_apigatewayv2_api.http_api_gateway.id
  route_key = "GET /python"
  target    = "integrations/${aws_apigatewayv2_integration.python.id}"
}

resource "aws_apigatewayv2_route" "node" {
  api_id    = aws_apigatewayv2_api.http_api_gateway.id
  route_key = "GET /node"
  target    = "integrations/${aws_apigatewayv2_integration.node.id}"
}

#Stage

resource "aws_apigatewayv2_stage" "prod" {
  api_id      = aws_apigatewayv2_api.http_api_gateway.id
  name        = "prod"
  auto_deploy = true
}


# Permissions

resource "aws_lambda_permission" "api_python" {
  statement_id  = "AllowAPIGatewayInvokePython"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.python.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_lambda_permission" "api_node" {
  statement_id  = "AllowAPIGatewayInvokeNode"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.node.function_name
  principal     = "apigateway.amazonaws.com"
}

