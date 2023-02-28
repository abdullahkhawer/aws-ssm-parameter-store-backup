resource "aws_cloudwatch_event_rule" "this" {
  name                = "${var.namespace}-${var.environment}-ssm-parameter-store-backup-rule"
  description         = "To invoke the ${var.namespace}-${var.environment}-ssm-parameter-store-backup Lambda function once daily."
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "this" {
  rule      = aws_cloudwatch_event_rule.this.name
  arn       = aws_lambda_function.this.arn
  target_id = "InvokeSSMLambda"
}

resource "aws_lambda_permission" "cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.this.arn
}
