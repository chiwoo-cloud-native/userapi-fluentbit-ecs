variable "context" {
  type = object({
    region       = string # describe default region to create a resource from aws
    region_alias = string
    project      = string # project name is usally account's project name or platform name
    environment  = string # Runtime Environment such as develop, stage, production
    env_alias    = string
    name_prefix  = string # Runtime Environment such as develop, stage, production
    owner        = string # project owner
    team         = string # Team name of Devops Transformation
    cost_center  = number # Cost Center
    domain       = string # public toolchain domain name (ex, tools.customer.co.kr)
    pri_domain   = string # private domain name (ex, tools.customer.co.kr)
    tags         = map(string)
  })
}

variable "vpc_id" { type = string }
variable "app_name" { type = string }
variable "repository_id" { type = string }
variable "repository_url" { type = string }
variable "source_location" { type = string }
variable "source_token_parameter_store" { type = string }
variable "source_type" {
  type    = string
  default = "GITHUB"
}
variable "buildspec" {
  type    = string
}
variable "build_branch" {
  type    = string
  default = "main"
}
#
# aws_codebuild_project
#
# https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html
variable "compute_type" {
  description = "One of BUILD_GENERAL1_SMALL, BUILD_GENERAL1_MEDIUM, BUILD_GENERAL1_LARGE, BUILD_GENERAL1_2XLARGE."
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

# https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html
variable "environment_type" {
  description = "One of LINUX_CONTAINER, LINUX_GPU_CONTAINER, WINDOWS_SERVER_2019_CONTAINER, ARM_CONTAINER."
  type        = string
  default     = "LINUX_CONTAINER"
}

variable "privileged_mode" {
  description = "Whether to enable running the Docker daemon inside a Docker container. Defaults to true."
  type        = bool
  default     = true
}

# https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
variable "environment_image" {
  description = "Docker image for build environment, e.g. 'aws/codebuild/standard:2.0' or 'aws/codebuild/eb-nodejs-6.10.0-amazonlinux-64:4.0.0'. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html"
  type        = string
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
}

variable "image_pull_credentials_type" {
  description = "One of CODEBUILD, SERVICE_ROLE"
  type        = string
  default     = "CODEBUILD"
}

# Cloudwatch
variable "retention_in_days" {
  description = "cloudwatch log group retention_in_days"
  type        = number
  default     = 30
}
