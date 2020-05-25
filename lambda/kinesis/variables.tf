variable "kinesis_stream_arn" {
  description = "The stream arn to be processed"
}

variable "batch_size" {
  default = 200
}

variable "function_name" {
  description = "The name of the function"
}

variable "path" {
  description = "The function's folder (the folder will be sent as the code for the lambda)"
}

variable "handler" {
  description = "The handler of the function (file.method)"
}

variable "variables" {
  type = "map"

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

variable "reserved_concurrent_executions" {
  default = -1
}
