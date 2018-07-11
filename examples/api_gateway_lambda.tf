module "api_gateway_lambda" {
  source              = "../api_gateway/method/lambda"
  rest_api_id         = "${aws_api_gateway_rest_api.api.id}"
  resource_id         = "${aws_api_gateway_rest_api.api.root_resource_id}"
  http_request_method = "GET"
  lambda_invoke_arn   = "${module.lambda_api_gateway_simple.lambda_invoke_arn}"
}
