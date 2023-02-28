# terraform-aws-ssm-parameter-store-backup

A Terraform Module to create AWS resources which are used to automatically take backup of all the parameters residing on AWS SSM Parameter Store using AWS Lambda function based on a Python script. It is executed daily via AWS CloudWatch or AWS EventBridge. Backup is taken in a `.json` file. Backup file is stored on an AWS S3 bucket.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0, < 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0, < 5.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | AWS region | `string` | `""` | Yes |
| namespace | Namespace / Project Name | `string` | `""` | Yes |
| environment | Environment Name | `string` | `""` | Yes |
