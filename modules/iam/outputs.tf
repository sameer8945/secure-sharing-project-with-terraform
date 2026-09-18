output "upload_arn" {

    value = aws_iam_role.upload.arn
  
}

output "download_role_arn" {
  value = aws_iam_role.download.arn
}

output "delete_role_arn" {
  value = aws_iam_role.delete.arn
}