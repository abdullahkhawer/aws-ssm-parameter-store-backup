resource "aws_lambda_function" "this" {
  function_name = "${var.namespace}-${var.environment}-ssm-parameter-store-backup"
  description   = "To take backup in the `.json` format of all the parameters residing on AWS SSM Parameter Store and store it on an AWS S3 bucket."
  role          = aws_iam_role.this.arn
  handler       = "ssm_backup.lambda_handler"
  runtime       = "python3.9"
  timeout       = 120

  environment {
    variables = {
      S3_BUCKET   = "${var.namespace}-${var.environment}-ssm-parameter-store-backups-bucket"
      KMS_KEY_ARN = data.aws_kms_key.s3.arn
    }
  }

  depends_on       = [null_resource.local_package, data.archive_file.lambda]
  source_code_hash = data.archive_file.lambda.output_base64sha256
  filename         = data.archive_file.lambda.output_path
}

resource "null_resource" "local_package" {
  triggers = { always_run = "${timestamp()}" }

  provisioner "local-exec" {
    command = "pip3 install -r ${path.module}/requirements.txt -t ${path.module}/function --no-cache-dir --upgrade"
  }
}

data "archive_file" "lambda" {
  depends_on       = [null_resource.local_package]
  type             = "zip"
  source_dir       = "${path.module}/function/"
  output_file_mode = "0666"
  output_path      = "${path.module}/ssm_backup.zip"
}
