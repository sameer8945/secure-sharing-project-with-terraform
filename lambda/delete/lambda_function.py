import json
import os
import boto3

s3 = boto3.client("s3")
dynamodb = boto3.resource("dynamodb")

BUCKET_NAME = os.environ["S3_BUCKET"]
TABLE_NAME = os.environ["DYNAMODB_TABLE"]

table = dynamodb.Table(TABLE_NAME)


def lambda_handler(event, context):
    code = event.get("pathParameters", {}).get("code")

    if not code:
        return {
            "statusCode": 400,
            "body": json.dumps({
                "message": "Share code is required"
            })
        }

    response = table.get_item(
        Key={
            "share_code": code
        }
    )

    item = response.get("Item")

    if not item:
        return {
            "statusCode": 404,
            "body": json.dumps({
                "message": "File not found"
            })
        }

    s3.delete_object(
        Bucket=BUCKET_NAME,
        Key=item["s3_key"]
    )

    table.delete_item(
        Key={
            "share_code": code
        }
    )

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": "File deleted successfully",
            "share_code": code
        })
    }