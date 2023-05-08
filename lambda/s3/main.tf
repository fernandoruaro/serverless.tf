locals {
  s3_policy = [<<EOF
{
      "Effect": "Allow",
      "Action": ["s3:GetObject"],
      "Resource": "arn:aws:s3:::${var.bucket_name}/*"
}
EOF
  ]
}

resource "aws_lambda_permission" "lambda" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = module.default.lambda_function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.bucket_arn
}

resource "aws_s3_bucket_notification" "lambda" {
  bucket = var.bucket_name

  lambda_function {
    id                  = "${var.bucket_name}-${module.default.lambda_function_name}"
    lambda_function_arn = module.default.lambda_arn
    events              = var.trigger_events
    filter_suffix       = var.bucket_notification_extension
  }
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
  extra_policy_statements        = compact(concat(local.s3_policy, var.extra_policy_statements))
  vpc_config_enabled             = var.vpc_config_enabled
  runtime                        = var.runtime
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  layers                         = var.layers
  source_code_hash               = var.source_code_hash
  tags                           = var.tags

}
