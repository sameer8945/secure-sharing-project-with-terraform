import json
import os
import boto3
import base64

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

    table.update_item(
        Key={
            "share_code": code
        },
        UpdateExpression="SET view_count = view_count + :one",
        ExpressionAttributeValues={
            ":one": 1
        }
    )

    s3_response = s3.get_object(
        Bucket=BUCKET_NAME,
        Key=item["s3_key"]
    )

    file_data = s3_response["Body"].read()

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/octet-stream",
            "Content-Disposition": f'attachment; filename="{item["file_name"]}"'
        },
        "isBase64Encoded": True,
        "body": base64.b64encode(file_data).decode("utf-8")
    }