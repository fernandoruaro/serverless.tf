variable "rest_api_id" {}
variable "resource_id" {}
variable "http_request_method" {}

variable "authorization" {
  default = ""
}

variable "authorizer_id" {
  default = ""
}

variable "request_parameters" {
  type = "map"

  default = {}
}

variable "service" {}

variable "action" {}

variable "status_code" {
  default = "200"
}

variable "api_key_required" {
  default = false
}

variable "credentials" {}
