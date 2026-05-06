output "rest_api_node_url" {
  value = "${aws_api_gateway_stage.prod_stage.invoke_url}/node?name=Antman"
}

output "http_api_node_url" {
  value       = "${aws_apigatewayv2_stage.prod.invoke_url}/node?name=Antman"
}

output "rest_api_python_url" {
  value = "${aws_api_gateway_stage.prod_stage.invoke_url}/python?name=Antman"
}

output "http_api_python_url" {
  value       = "${aws_apigatewayv2_stage.prod.invoke_url}/python?name=Antman"
}
