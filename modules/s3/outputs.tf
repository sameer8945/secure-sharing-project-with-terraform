output "bucket_name" {

    description = "name of the s3 bucket"
    value = aws_s3_bucket.files.bucket
  
}

output "bucket_arn" {
  
   description = "arn of s3 bucket"
   value = aws_s3_bucket.files.arn
}
