import os
import boto3
import random
import string
import base64
import json

s3 = boto3.client("s3")
dynamodb = boto3.resource("dynamodb")

BUCKET_NAME = os.environ["S3_BUCKET"]
TABLE_NAME = os.environ["DYNAMODB_TABLE"]

table = dynamodb.Table(TABLE_NAME)

def generate_code():
    return ''.join(random.choices(string.ascii_uppercase + string.digits, k=6))


def lambda_handler(event, context):
    share_code = generate_code()

    body = event.get("body")
    filename = event.get("queryStringParameters", {}).get("filename")

    if not body or not filename:
        return {
            "statusCode": 400,
            "body": "File and filename are required"
        }

    file_data = base64.b64decode(body)

    s3_key = f"files/{share_code}/{filename}"

    s3.put_object(
        Bucket=BUCKET_NAME,
        Key=s3_key,
        Body=file_data
    )

    table.put_item(
        Item={
            "share_code": share_code,
            "file_name": filename,
            "s3_key": s3_key,
            "view_count": 0
        }
    )

    return {
    "statusCode": 200,
    "body": json.dumps({
        "message": "File uploaded successfully",
        "share_code": share_code,
        "file_name": filename,
        "view_count": 0
    })
    }