resource "aws_dynamodb_table" "shares" {

    name = var.table_name
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "share_code"

    attribute {
      name = "share_code"
      type = "S"
    }
  
}