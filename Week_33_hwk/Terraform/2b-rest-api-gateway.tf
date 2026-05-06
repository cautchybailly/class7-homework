# Full chain required: API → Resource → Method → Integration → Deploy → Stage

#REST API Gateway
resource "aws_api_gateway_rest_api" "antman_rest_api" {
  name        = "${local.name_prefix}-rest-api"
}

#Resource for the root path ("/") is created by default, so we can skip that and create resources for our endpoints
resource "aws_api_gateway_resource" "python_resource" {
  rest_api_id = aws_api_gateway_rest_api.antman_rest_api.id
  parent_id   = aws_api_gateway_rest_api.antman_rest_api.root_resource_id
  path_part   = "python"
}  

resource "aws_api_gateway_resource" "node_resource" {
  rest_api_id = aws_api_gateway_rest_api.antman_rest_api.id
  parent_id   = aws_api_gateway_rest_api.antman_rest_api.root_resource_id
  path_part   = "node"
}

# Methods
resource "aws_api_gateway_method" "python_method" {
  rest_api_id   = aws_api_gateway_rest_api.antman_rest_api.id
  resource_id   = aws_api_gateway_resource.python_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "node_method" {
  rest_api_id   = aws_api_gateway_rest_api.antman_rest_api.id
  resource_id   = aws_api_gateway_resource.node_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# Integration
resource "aws_api_gateway_integration" "python_integration" {
  rest_api_id = aws_api_gateway_rest_api.antman_rest_api.id
  resource_id = aws_api_gateway_resource.python_resource.id
  http_method = aws_api_gateway_method.python_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.python.invoke_arn
}

resource "aws_api_gateway_integration" "node_integration" {
  rest_api_id = aws_api_gateway_rest_api.antman_rest_api.id
  resource_id = aws_api_gateway_resource.node_resource.id
  http_method = aws_api_gateway_method.node_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.node.invoke_arn
}

# Deployment and Stage
resource "aws_api_gateway_deployment" "rest_api_deployment" {
    rest_api_id = aws_api_gateway_rest_api.antman_rest_api.id

    triggers = {
        redeployment = sha1(jsonencode([
            aws_api_gateway_resource.python_resource.id,
            aws_api_gateway_resource.node_resource.id,
            aws_api_gateway_method.python_method.http_method,
            aws_api_gateway_method.node_method.http_method,
            aws_api_gateway_integration.python_integration.uri,
            aws_api_gateway_integration.node_integration.uri
        ]))
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_api_gateway_stage" "prod_stage" {
    stage_name    = "prod"
    rest_api_id   = aws_api_gateway_rest_api.antman_rest_api.id
    deployment_id = aws_api_gateway_deployment.rest_api_deployment.id
}

