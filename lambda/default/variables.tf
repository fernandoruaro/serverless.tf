variable "function_name" {
  description = "The name of the function"
}

variable "path" {
  description = "The function's folder (the folder will be sent as the code for the lambda)"
  default = null
}

variable "s3_bucket" {
  description = "The function's s3 bucket"
  default = null
}

variable "s3_key" {
  description = "The function's s3 key"
  default = null
}

variable "handler" {
  description = "The handler of the function (file.method)"
}

variable "variables" {
  type = map

  default = {
    EMPTY_ENVIRONMENT = true
  }
}

variable "timeout" {
  default = 3
}

variable "vpc_config_enabled" {
  default = false
}

variable "vpc_config" {
  default = {}
  type = map(list(string))
}

variable "extra_policy_statements" {
  type    = "list"
  default = []
}

variable "runtime" {
  default = "nodejs8.10"
}

variable "memory_size" {
  default = 128
}

variable "provisioned_concurrent_executions" {
  default = 0
}

variable "reserved_concurrent_executions" {
  default = -1
}

variable "publish" {
  default = false
}

variable "layers" {
  type    = "list"
  default = []
}
