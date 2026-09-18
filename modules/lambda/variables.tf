variable "upload_role_arn" {
  description = "IAM role ARN for upload Lambda"
  type        = string
}

variable "download_role_arn" {
  description = "IAM role ARN for download Lambda"
  type        = string
}

variable "delete_role_arn" {
  description = "IAM role ARN for delete Lambda"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

