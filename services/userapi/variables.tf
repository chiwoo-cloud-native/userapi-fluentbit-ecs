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
variable "fluent_bit_image" { type = string }
# https://github.com/parlicious/golf.git"

#
#variable "alb_hosts" {
#  description = "Frontend ALB routing hostnames"
#  type        = list(string)
#  default     = []
#}
#
#variable "alb_paths" {
#  description = "Frontend ALB routing paths"
#  type        = list(string)
#  default     = []
#}
#
#variable "health_check_path" { type = string }

#variable "desired_count" {
#  type    = number
#  default = 1
#}
#
#variable "environments" {
#  type    = list(any)
#  default = []
#}
#
#variable "secrets" {
#  type    = list(any)
#  default = []
#}
#
#variable "retention_in_days" {
#  type    = number
#  default = 90
#}
#
