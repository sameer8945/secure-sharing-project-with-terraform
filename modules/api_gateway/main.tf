resource "aws_apigatewayv2_api" "main" {
  name          = "secure-sharing-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "DELETE", "OPTIONS"]
    allow_headers = ["Content-Type"]
  }
}

resource "aws_apigatewayv2_integration" "upload" {

    api_id = aws_apigatewayv2_api.main.id
    integration_type       = "AWS_PROXY"
    integration_uri        = var.upload_lambda_arn
    payload_format_version = "2.0"
  
}

resource "aws_apigatewayv2_route" "upload" {

    api_id    = aws_apigatewayv2_api.main.id
    route_key = "POST /upload"
    target    = "integrations/${aws_apigatewayv2_integration.upload.id}"
  
}

resource "aws_lambda_permission" "upload" {
  statement_id  = "AllowAPIGatewayInvokeUpload"
  action        = "lambda:InvokeFunction"
  function_name = "secure-sharing-upload"
  principal     = "apigateway.amazonaws.com"
}

resource "aws_apigatewayv2_integration" "download" {
  api_id                 = aws_apigatewayv2_api.main.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.download_lambda_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "download" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /download/{code}"
  target    = "integrations/${aws_apigatewayv2_integration.download.id}"
}

resource "aws_lambda_permission" "download" {
  statement_id  = "AllowAPIGatewayInvokeDownload"
  action        = "lambda:InvokeFunction"
  function_name = "secure-sharing-download"
  principal     = "apigateway.amazonaws.com"
}

resource "aws_apigatewayv2_integration" "delete" {
  api_id                 = aws_apigatewayv2_api.main.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.delete_lambda_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "delete" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "DELETE /delete/{code}"
  target    = "integrations/${aws_apigatewayv2_integration.delete.id}"
}

resource "aws_lambda_permission" "delete" {
  statement_id  = "AllowAPIGatewayInvokeDelete"
  action        = "lambda:InvokeFunction"
  function_name = "secure-sharing-delete"
  principal     = "apigateway.amazonaws.com"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "$default"
  auto_deploy = true
}