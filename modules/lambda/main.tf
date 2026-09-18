data "archive_file" "upload" {   
  
  #to zip our python file , archive_file is a in-built terraform dat source that does that

  type        = "zip"
  source_file = "${path.root}/../../lambda/upload/lambda_function.py"
  output_path = "${path.root}/../../lambda/upload/lambda_function.zip"    
  
}

data "archive_file" "download" {
  type        = "zip"
  source_file = "${path.root}/../../lambda/download/lambda_function.py"
  output_path = "${path.root}/../../lambda/download/lambda_function.zip"
}

data "archive_file" "delete" {
  type        = "zip"
  source_file = "${path.root}/../../lambda/delete/lambda_function.py"
  output_path = "${path.root}/../../lambda/delete/lambda_function.zip"
}

resource "aws_lambda_function" "upload" {
  function_name = "secure-sharing-upload"

  filename = data.archive_file.upload.output_path

  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"

  role = var.upload_role_arn

  environment {
  variables = {
    S3_BUCKET       = var.s3_bucket_name
    DYNAMODB_TABLE  = var.dynamodb_table_name
  }
}
}

resource "aws_lambda_function" "download" {
  function_name = "secure-sharing-download"

  filename = data.archive_file.download.output_path

  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"

  role = var.download_role_arn

  environment {
  variables = {
    S3_BUCKET      = var.s3_bucket_name
    DYNAMODB_TABLE = var.dynamodb_table_name
  }
}
}

resource "aws_lambda_function" "delete" {
  function_name = "secure-sharing-delete"

  filename = data.archive_file.delete.output_path

  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"

  role = var.delete_role_arn

  environment {
  variables = {
    S3_BUCKET      = var.s3_bucket_name
    DYNAMODB_TABLE = var.dynamodb_table_name
  }
}
}