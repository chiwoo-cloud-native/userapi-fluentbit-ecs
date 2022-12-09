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

variable "app_name" { type = string }
# ECR
variable "container_image" {
  description = "container image"
  type        = string
  default     = null
}

variable "image_tag_mutability" {
  description = "image tag mutability"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "image scan on push"
  type        = bool
  default     = false
}

variable "ecr_force_delete_enabled" {
  description = "If true, will delete the repository even if it contains images."
  type        = bool
  default     = true
}

variable "ecr_encryption_type" {
  description = "The encryption type to use for the repository. Valid values are AES256 or KMS."
  type        = string
  default     = null
}

variable "ecr_kms_key" {
  description = "The ARN of the KMS key to use when encryption_type is KMS. If not specified, uses the default AWS managed key for ECR."
  type        = string
  default     = null
}

variable "ecr_image_limit" {
  description = "ECR docker image limit count."
  type        = number
  default     = 0
}
