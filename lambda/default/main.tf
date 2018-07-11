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
  role       = "${aws_iam_role.lambda.name}"
  policy_arn = "${aws_iam_policy.default.arn}"
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

## VPC POLICY: If the lambda runs inside a vpc, it needs specific policies to attache itself to the vpc ##
resource "aws_iam_role_policy_attachment" "vpc" {
  count      = "${length(var.vpc_config) == 0 ? 0 : 1}"
  role       = "${aws_iam_role.lambda.name}"
  policy_arn = "${aws_iam_policy.vpc.arn}"
}

resource "aws_iam_policy" "vpc" {
  count       = "${length(var.vpc_config) == 0 ? 0 : 1}"
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
  type        = "zip"
  source_dir  = "${var.path}"
  output_path = ".terraform/zips/${var.function_name}.zip"
}

resource "aws_lambda_function" "lambda" {
  filename         = "${data.archive_file.zip.output_path}"
  function_name    = "${var.function_name}"
  role             = "${aws_iam_role.lambda.arn}"
  handler          = "${var.handler}"
  source_code_hash = "${data.archive_file.zip.output_md5}"
  runtime          = "${var.runtime}"
  timeout          = "${var.timeout}"

  environment {
    variables = "${var.variables}"
  }

  vpc_config = "${var.vpc_config}"

  dead_letter_config {
    target_arn = "${aws_sqs_queue.dead_letter.arn}"
  }

  depends_on = ["aws_iam_policy.default"]
}

resource "aws_sqs_queue" "dead_letter" {
  name                      = "lambda-${var.function_name}-dead-letter"
  message_retention_seconds = 604800
  receive_wait_time_seconds = 20
}
