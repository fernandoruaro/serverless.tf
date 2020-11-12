resource "aws_lambda_permission" "lambda" {

  statement_id = "AllowExecutionFromSNS"
  action = "lambda:InvokeFunction"
  function_name = "${module.default.lambda_function_name}"
  principal = "sns.amazonaws.com"
  source_arn = "${var.topic_arn}"
}

resource "aws_s3_bucket_notification" "lambda" {
  bucket = "${var.bucket_name}"

  lambda_function {
    id                  = "${var.bucket_name}-${module.default.lambda_function_name}"
    lambda_function_arn = "${module.default.lambda_arn}"
    events              = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]
    filter_suffix       = "${var.bucket_notification_extension}"
  }
}

resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = "${var.topic_arn}"
  protocol  = "lambda"
  endpoint  = "${module.default.lambda_arn}"
}

module "default" {
  source = "../default"

  path                           = "${var.path}"
  timeout                        = "${var.timeout}"
  variables                      = "${var.variables}"
  handler                        = "${var.handler}"
  function_name                  = "${var.function_name}"
  vpc_config                     = "${var.vpc_config}"
  extra_policy_statements        = "${compact(var.extra_policy_statements)}"
  vpc_config_enabled             = "${var.vpc_config_enabled}"
  runtime                        = "${var.runtime}"
  reserved_concurrent_executions = "${var.reserved_concurrent_executions}"
}