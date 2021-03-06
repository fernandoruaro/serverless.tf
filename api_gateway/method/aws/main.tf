data "aws_region" "current" {}

resource "aws_api_gateway_method" "request" {
  rest_api_id      = "${var.rest_api_id}"
  resource_id      = "${var.resource_id}"
  authorization    = "${var.authorization != "" ? var.authorization : (var.authorizer_id == "" ? "NONE" : "CUSTOM") }"
  http_method      = "${var.http_request_method}"
  authorizer_id    = "${var.authorizer_id}"
  api_key_required = "${var.api_key_required}"
}

resource "aws_api_gateway_integration" "integration_request" {
  rest_api_id             = "${var.rest_api_id}"
  resource_id             = "${var.resource_id}"
  http_method             = "${var.http_request_method}"
  credentials             = "${var.credentials}"
  integration_http_method = "POST"
  type                    = "AWS"
  request_parameters      = "${var.request_parameters}"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:${var.service}:action/${var.action}"
  depends_on              = ["aws_api_gateway_method.request"]
}

resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.http_request_method}"
  status_code = "${var.status_code}"
  depends_on  = ["aws_api_gateway_integration.integration_request"]
}

resource "aws_api_gateway_method_response" "response" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${var.http_request_method}"
  status_code = "${var.status_code}"

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = ["aws_api_gateway_integration_response.integration_response"]
}
