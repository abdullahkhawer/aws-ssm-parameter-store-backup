resource "aws_iam_policy" "this" {
  name = "${var.namespace}-${var.environment}-ssm-parameter-store-backup-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:DescribeParameters",
          "ssm:GetParameterHistory",
          "ssm:GetParametersByPath",
          "ssm:GetParameters",
          "ssm:GetParameter"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:ListAllMyBuckets"
        ],
        Resource = "arn:aws:s3:::*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:GetBucketLocation",
          "s3:AbortMultipartUpload",
          "s3:GetObjectAcl",
          "s3:GetObjectVersion",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
          "s3:GetObject",
          "s3:PutObjectAcl",
          "s3:PutObject",
          "s3:GetObjectVersionAcl"
        ],
        Resource = [
          "arn:aws:s3:::${var.namespace}-${var.environment}-ssm-parameter-store-backups-bucket",
          "arn:aws:s3:::${var.namespace}-${var.environment}-ssm-parameter-store-backups-bucket/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        Resource = [
          data.aws_kms_key.ssm.arn,
          data.aws_kms_key.s3.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role" "this" {
  name                = "${var.namespace}-${var.environment}-ssm-parameter-store-backup-role"
  managed_policy_arns = [aws_iam_policy.this.arn]
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "lambda.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
}