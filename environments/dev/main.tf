module "s3" {

  source = "../../modules/s3"

  bucket_name = "secure-sharing-bucket-2026-253"

}

module "dynamodb" {

  source = "../../modules/dynamodb"

  table_name = "secure-sharing-dev"


}

module "iam" {
  source = "../../modules/iam"

  s3_bucket_arn      = module.s3.bucket_arn
  dynamodb_table_arn = module.dynamodb.table_arn
}

module "lambda" {

  source = "../../modules/lambda"

  upload_role_arn   = module.iam.upload_arn
  download_role_arn = module.iam.download_role_arn
  delete_role_arn   = module.iam.delete_role_arn

  s3_bucket_name      = module.s3.bucket_name
  dynamodb_table_name = module.dynamodb.table_name

}

module "api_gateway" {
  source = "../../modules/api_gateway"

  upload_lambda_arn   = module.lambda.upload_lambda_arn
  download_lambda_arn = module.lambda.download_lambda_arn
  delete_lambda_arn   = module.lambda.delete_lambda_arn
}

