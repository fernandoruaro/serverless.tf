locals {
  sqs_policy = [<<EOF
{
      "Effect": "Allow",
      "Action": ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"],
      "Resource": "${var.sqs_arn}"
}
EOF
  ]
}

resource "aws_lambda_permission" "lambda" {
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = "${module.default.lambda_function_name}"
  principal     = "sqs.amazonaws.com"
  source_arn    = "${var.sqs_arn}"
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  batch_size       = "${var.batch_size}"
  event_source_arn = "${var.sqs_arn}"
  function_name    = "${module.default.lambda_function_name}"
}

module "default" {
  source = "../default"

  path                           = "${var.path}"
  timeout                        = "${var.timeout}"
  variables                      = "${var.variables}"
  handler                        = "${var.handler}"
  function_name                  = "${var.function_name}"
  vpc_config                     = "${var.vpc_config}"
  extra_policy_statements        = "${compact(concat(local.sqs_policy,var.extra_policy_statements))}"
  vpc_config_enabled             = "${var.vpc_config_enabled}"
  runtime                        = "${var.runtime}"
  memory_size                    = "${var.memory_size}"
  reserved_concurrent_executions = "${var.reserved_concurrent_executions}"
  layers                         = "${var.layers}"
}
