resource "aws_api_gateway_rest_api" "api" {
  name        = "serverless-test"
  description = ""
}

module "api_gateway_resource" {
  source      = "../api_gateway/resource"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part   = "path"
}
