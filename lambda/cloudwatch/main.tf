resource "aws_cloudwatch_event_rule" "rule" {
  name                = "rule-${var.function_name}"
  description         = "Scheduler for ${var.function_name}"
  schedule_expression = "${var.schedule_expression}"
}

resource "aws_lambda_permission" "lambda" {
  statement_id  = "AllowExecutionFromCloudwatchEvent"
  action        = "lambda:InvokeFunction"
  function_name = "${module.default.lambda_function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.rule.arn}"
}

resource "aws_cloudwatch_event_target" "target" {
  rule = "${aws_cloudwatch_event_rule.rule.name}"
  arn  = "${module.default.lambda_arn}"
}

module "default" {
  source = "../default"

  path                           = "${var.path}"
  s3_bucket                      = "${var.s3_bucket}"
  s3_key                         = "${var.s3_key}"
  timeout                        = "${var.timeout}"
  variables                      = "${var.variables}"
  handler                        = "${var.handler}"
  function_name                  = "${var.function_name}"
  vpc_config                     = "${var.vpc_config}"
  extra_policy_statements        = "${var.extra_policy_statements}"
  vpc_config_enabled             = "${var.vpc_config_enabled}"
  runtime                        = "${var.runtime}"
  memory_size                    = "${var.memory_size}"
  reserved_concurrent_executions = "${var.reserved_concurrent_executions}"
  layers                         = "${var.layers}"
}
