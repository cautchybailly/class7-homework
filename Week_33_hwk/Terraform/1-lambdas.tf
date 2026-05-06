############################################################################
# IAM policy needed for Lambda execution
############################################################################

# Lambda execution role
resource "aws_iam_role" "lambda_role" {
  name = "${local.name_prefix}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
      Service = "lambda.amazonaws.com" }
    }]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


############################################################################
# Lambda-node archive
############################################################################

resource "aws_lambda_function" "node" {
  function_name = "${local.name_prefix}-node-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "antman-node-lambda.handler"
  runtime       = "nodejs24.x"

  filename = data.archive_file.node_zip.output_path
  source_code_hash = data.archive_file.node_zip.output_base64sha256
}

# zip node.zip index.js
data "archive_file" "node_zip" {
  type        = "zip"
  source_file = "${path.module}/${local.name_prefix}-node-lambda.js"
  output_path = "${path.module}/node-lambda.zip"
}

############################################################################
# Lambda-python archive
############################################################################

resource "aws_lambda_function" "python" {
  function_name = "${local.name_prefix}-python-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "antman-python-lambda.handler"
  runtime       = "python3.12"

  filename = data.archive_file.python_zip.output_path
  source_code_hash = data.archive_file.python_zip.output_base64sha256
}

# zip lambda.zip index.js
data "archive_file" "python_zip" {
  type        = "zip"
  source_file = "${path.module}/${local.name_prefix}-python-lambda.py"
  output_path = "${path.module}/python-lambda.zip"
}
  