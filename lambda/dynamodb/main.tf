data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_lambda_event_source_mapping" "lambda" {
  batch_size        = "${var.batch_size}"
  event_source_arn  = "${var.dynamodb_stream_arn}"
  enabled           = true
  function_name     = "${module.default.lambda_arn}"
  starting_position = "TRIM_HORIZON"
}

locals {
  dynamodb_policy = [<<EOF
{
    "Effect": "Allow",
    "Action": ["dynamodb:*"],
    "Resource": "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${element(split("/", var.dynamodb_stream_arn),1)}/stream/*"
}
EOF
  ]
}

module "default" {
  source = "../default"

  path                    = "${var.path}"
  timeout                 = "${var.timeout}"
  variables               = "${var.variables}"
  handler                 = "${var.handler}"
  function_name           = "${var.function_name}"
  vpc_config              = "${var.vpc_config}"
  extra_policy_statements = "${compact(concat(local.dynamodb_policy,var.extra_policy_statements))}"
  vpc_config_enabled      = "${var.vpc_config_enabled}"
  runtime                 = "${var.runtime}"
  memory_size             = "${var.memory_size}"
}
