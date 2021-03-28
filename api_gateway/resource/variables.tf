variable "rest_api_id" {}
variable "parent_id" {}
variable "path_part" {}

variable "extra_cors_headers" {
  type    = list
  default = []
}
