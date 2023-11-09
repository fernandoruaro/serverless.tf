resource "aws_lambda_event_source_mapping" "lambda" {
  batch_size        = var.batch_size
  event_source_arn  = var.kinesis_stream_arn
  enabled           = true
  function_name     = module.default.lambda_arn
  starting_position = "TRIM_HORIZON"
  parallelization_factor = var.parallelization_factor
}

locals {
  kinesis_policy = [<<EOF
{
      "Effect": "Allow",
      "Action": ["kinesis:*"],
      "Resource": "${var.kinesis_stream_arn}"
}
EOF
  ]
}

module "default" {
  source = "../default"

  path                           = var.path
  s3_bucket                      = var.s3_bucket
  s3_key                         = var.s3_key
  timeout                        = var.timeout
  variables                      = var.variables
  handler                        = var.handler
  function_name                  = var.function_name
  vpc_config                     = var.vpc_config
  extra_policy_statements        = compact(concat(local.kinesis_policy, var.extra_policy_statements))
  vpc_config_enabled             = var.vpc_config_enabled
  runtime                        = var.runtime
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  layers                         = var.layers
  source_code_hash               = var.source_code_hash
  tags                           = var.tags

}
