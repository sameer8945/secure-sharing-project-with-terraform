# Secure File Sharing Platform

A simple and secure file-sharing platform built using **AWS and Terraform**.

The project allows users to upload a file and receive a unique **6-character share code**. Anyone with the share code can download the file, while the creator can delete the shared file using the same code.

The application uses **Amazon S3** to store files and **Amazon DynamoDB** to store file metadata and track the number of downloads. **AWS Lambda** handles the application's backend logic, while **Amazon API Gateway** provides HTTP endpoints for the frontend to communicate with the backend.

The entire AWS infrastructure is created and managed using **Terraform**, making the infrastructure reproducible and easy to manage.

## How It Works

1. The user selects a file from the frontend.
2. The file is uploaded to the backend through API Gateway.
3. The Upload Lambda function stores the file in a private S3 bucket.
4. A unique 6-character share code is generated for the file.
5. File metadata and the share code are stored in DynamoDB.
6. The user can share the code with someone else.
7. The recipient enters the share code to download the file.
8. Every successful download increments the `view_count` in DynamoDB.
9. The creator can delete the file using the share code.
10. Deleting a file removes both the S3 object and its DynamoDB metadata.

## Architecture

```text
                  ┌─────────────────┐
                  │    Frontend     │
                  │   HTML/CSS/JS   │
                  └────────┬────────┘
                           │
                           ▼
                  ┌─────────────────┐
                  │  API Gateway    │
                  └───────┬─────────┘
                          │
             ┌────────────┼────────────┐
             ▼            ▼            ▼
        ┌─────────┐  ┌──────────┐  ┌─────────┐
        │ Upload  │  │ Download │  │ Delete  │
        │ Lambda  │  │  Lambda  │  │ Lambda  │
        └────┬────┘  └────┬─────┘  └────┬────┘
             │            │              │
             └────────────┼──────────────┘
                          │
                    ┌─────┴─────┐
                    │           │
                    ▼           ▼
               ┌─────────┐ ┌────────────┐
               │   S3    │ │ DynamoDB   │
               │  Files  │ │  Metadata  │
               └─────────┘ └────────────┘


## AWS Services Used

Amazon S3 — Private file storage
Amazon DynamoDB — File metadata and download count
AWS Lambda — Backend logic
Amazon API Gateway — HTTP API endpoints
AWS IAM — Access control and least-privilege permissions
Amazon CloudWatch — Lambda logging
Terraform — Infrastructure provisioning and management

## 🚀 How to Run

1. Clone the repository.
2. Configure your AWS credentials using `aws configure`.
3. Go to the `environments/dev` directory.
4. Run `terraform init`.
5. Run `terraform apply` and type `yes`.
6. Copy the API Gateway URL from the Terraform output command.
7. Add the API URL to `frontend/index.html`.
8. Open `frontend/index.html` using VS Code Live Server.
9. Use the website to upload, download, and delete files using the generated share code.

## 🧹 After Testing

Run `terraform destroy` from the `environments/dev` directory to remove the AWS resources.