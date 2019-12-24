module "lambda_default_simple" {
  source = "../lambda/default"

  function_name = "lambda-default-simple"
  handler       = "index.handler"
  path          = "./code"
}

module "lambda_default_concurrent" {
  source = "../lambda/default"

  function_name = "lambda-default-concurrent"
  handler       = "index.handler"
  path          = "./code"
  provisioned_concurrent_executions = 1
}


module "lambda_default_policy" {
  source = "../lambda/default"

  function_name = "lambda-default-policy"
  handler       = "index.handler"
  path          = "./code"

  extra_policy_statements = [
    <<EOF
{
      "Effect": "Allow",
      "Action": ["dynamodb:*"],
      "Resource": "arn:aws:dynamodb:*"
}
EOF
    ,
  ]
}

resource "aws_vpc" "main" {
  cidr_block           = "10.254.0.0/16"
  enable_dns_hostnames = true
}

data "aws_region" "current" {}

resource "aws_subnet" "subnet" {
  availability_zone = "${data.aws_region.current.name}a"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${cidrsubnet(aws_vpc.main.cidr_block, 4, 0)}"
}

resource "aws_security_group" "security_group" {
  vpc_id = "${aws_vpc.main.id}"
  name   = "lambda-default-security-group"
}

module "lambda_default_vpc" {
  source = "../lambda/default"

  function_name = "lambda-default-vpc"
  handler       = "index.handler"
  path          = "./code"

  vpc_config_enabled = true

  vpc_config = {
    subnet_ids         = ["${aws_subnet.subnet.id}"]
    security_group_ids = ["${aws_security_group.security_group.id}"]
  }
}
