variable "context" {
  type = object({
    project     = string
    region      = string
    environment = string
    team        = string
    owner       = string
    cost_center = number
    domain      = string
    pri_domain  = string
  })
}

variable "app_name" { type = string }
variable "cpu" { type = number }
variable "memory" { type = number }
variable "port" { type = number }
variable "source_location" { type = string }
variable "source_token_parameter_store" { type = string }
# https://github.com/parlicious/golf.git"
