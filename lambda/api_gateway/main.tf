resource "aws_lambda_permission" "lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${module.default.lambda_arn}"
  principal     = "apigateway.amazonaws.com"
}

module "default" {
  source = "../default"

  path                    = "${var.path}"
  timeout                 = "${var.timeout}"
  variables               = "${var.variables}"
  handler                 = "${var.handler}"
  function_name           = "${var.function_name}"
  extra_policy_statements = "${var.extra_policy_statements}"
  vpc_config              = "${var.vpc_config}"
  vpc_config_enabled      = "${var.vpc_config_enabled}"
  runtime                 = "${var.runtime}"
  memory_size             = "${var.memory_size}"
  provisioned_concurrent_executions = "${var.provisioned_concurrent_executions}"
}

