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

variable "cluster_name" {
  type    = string
  default = null
}

variable "capacity_providers" {
  description = "List of short names of one or more capacity providers to associate with the cluster. Valid values also include FARGATE and FARGATE_SPOT."
  type        = list(string)
  default     = ["FARGATE", "FARGATE_SPOT"]
}

variable "default_capacity_provider_strategy" {
  description = "The capacity provider strategy to use by default for the cluster. Can be one or more."
  type        = list(map(any))
  default     = [
    {
      capacity_provider = "FARGATE"
      weight            = 1
    }
  ]
}

variable "container_insights" {
  description = "Controls if ECS Cluster has container insights enabled"
  type        = bool
  default     = true
}

variable "create_ecs_task_execution_role" {
  description = "Whether to create ECS task-execution-role."
  type        = bool
  default     = true
}

variable "ecs_task_role_name" {
  description = "Whether to create task-execution-role for this ECS Cluster. if not set automatically generate it."
  type        = string
  default     = null
}
