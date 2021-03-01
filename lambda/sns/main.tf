locals {
  sns_policy = []
}

resource "aws_lambda_permission" "lambda" {

  statement_id = "AllowExecutionFromSNS"
  action = "lambda:InvokeFunction"
  function_name = "${module.default.lambda_function_name}"
  principal = "sns.amazonaws.com"
  source_arn = "${var.topic_arn}"
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
  extra_policy_statements        = "${compact(concat(local.sns_policy,var.extra_policy_statements))}"
  vpc_config_enabled             = "${var.vpc_config_enabled}"
  runtime                        = "${var.runtime}"
  memory_size                    = "${var.memory_size}"
  reserved_concurrent_executions = "${var.reserved_concurrent_executions}"
  layers                         = "[${var.layers}]"
}
