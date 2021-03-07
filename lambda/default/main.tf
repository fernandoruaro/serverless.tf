locals {
  vpc_config = var.vpc_config_enabled ? [var.vpc_config] : []
}

resource "aws_iam_role" "lambda" {
  name = "lambda-${var.function_name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

locals {
  default_statements = [
    <<EOF
    {
      "Effect": "Allow",
      "Action": ["logs:*"],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": ["sqs:SendMessage"],
      "Resource": "${aws_sqs_queue.dead_letter.arn}"
    }
EOF
    ,
  ]
}

## DEFAULT POLICY: Policies that all lambdas will have. Logging, dead letter, ... ##
resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.default.arn
}

resource "aws_iam_policy" "default" {
  name        = "${var.function_name}-default"
  path        = "/"
  description = "Lambda Policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [${join(",",compact(concat(local.default_statements,var.extra_policy_statements)))}]
}
EOF
}

# VPC POLICY: If the lambda runs inside a vpc, it needs specific policies to attache itself to the vpc ##
resource "aws_iam_role_policy_attachment" "vpc" {
  count      = var.vpc_config_enabled ? 1 : 0
  role       = aws_iam_role.lambda.name
  policy_arn =  aws_iam_policy.vpc[0].arn
}

resource "aws_iam_policy" "vpc" {
  count       = var.vpc_config_enabled ? 1 : 0
  name        = "${var.function_name}-vpc"
  path        = "/"
  description = "VPC Policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

data "archive_file" "zip" {
  count       = var.path != null ? 1 : 0
  type        = "zip"
  source_dir  = "${var.path}"
  output_path = ".terraform/zips/${var.function_name}.zip"
}

resource "aws_lambda_function" "default" {
  filename                       = var.path != null ? data.archive_file.zip[0].output_path : null
  s3_bucket                      = var.s3_bucket
  s3_key                         = var.s3_key
  function_name                  = var.function_name
  role                           = aws_iam_role.lambda.arn
  handler                        = var.handler
  source_code_hash               = var.path != null ? filebase64sha256(data.archive_file.zip[0].output_path) : sha256(var.s3_key)
  runtime                        = var.runtime
  timeout                        = var.timeout
  memory_size                    = var.memory_size
  publish                        = var.publish || var.provisioned_concurrent_executions > 0
  reserved_concurrent_executions = var.reserved_concurrent_executions
  layers                         = var.layers


  dynamic "vpc_config" {
    for_each = local.vpc_config
    content {
      security_group_ids = vpc_config.value["security_group_ids"]
      subnet_ids = vpc_config.value["subnet_ids"]
    }
  }

  environment {
    variables = var.variables
  }

  dead_letter_config {
    target_arn = aws_sqs_queue.dead_letter.arn
  }

  depends_on = [aws_iam_role_policy_attachment.default, aws_iam_role_policy_attachment.vpc]
}


resource "aws_sqs_queue" "dead_letter" {
  name                      = "lambda-${var.function_name}-dead-letter"
  message_retention_seconds = 604800
  receive_wait_time_seconds = 20
}

resource "aws_lambda_provisioned_concurrency_config" "lambda_provisioned_concurrency_config" {
  count                             = var.provisioned_concurrent_executions > 0 ? 1 : 0
  function_name                     = aws_lambda_function.default.function_name
  provisioned_concurrent_executions = var.provisioned_concurrent_executions
  qualifier                         = aws_lambda_function.default.version
}
