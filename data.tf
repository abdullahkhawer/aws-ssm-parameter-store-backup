data "aws_kms_key" "ssm" {
  key_id = "alias/aws/ssm"
}

data "aws_kms_key" "s3" {
  key_id = "alias/aws/s3"
}