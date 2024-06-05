# terraform-aws-ssm-parameter-store-backup

- Founder: Abdullah Khawer (LinkedIn: https://www.linkedin.com/in/abdullah-khawer/)

## Introduction

A Terraform module to create AWS resources which are used to automatically take backup of all the parameters residing on AWS SSM Parameter Store in JSON format and store it on AWS S3 bucket using AWS Lambda function based on Python. It is executed daily via AWS CloudWatch or AWS EventBridge.

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
