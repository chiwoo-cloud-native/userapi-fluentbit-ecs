locals {
  project      = module.ctx.project
  name_prefix  = module.ctx.name_prefix
  region       = module.ctx.region
  tags         = module.ctx.tags
  cluster_name = "${local.name_prefix}-demo-ecs"
  elb_name     = format("%s-%s", local.name_prefix, "pub-alb")
  account_id   = data.aws_caller_identity.current.account_id
}

module "ctx" {
  source  = "../../modules/context/"
  context = var.context
}

module "td_app" {
  source          = "../../modules/ecss/definitions/"
  app_name        = var.app_name
  name_prefix     = local.name_prefix
  container_image = format("%s:latest", module.ecr.repository_url)
  cpu             = var.cpu
  memory          = var.memory
  port_mappings   = [
    {
      containerPort = var.port
      hostPort      = var.port
      protocol      = "tcp"
    }
  ]
}

module "app" {
  source                = "../../modules/ecss/"
  context               = module.ctx.context
  # delete_service = true
  cluster_name          = local.cluster_name
  app_name              = var.app_name
  listener_port         = 443
  task_cpu              = var.cpu
  task_memory           = var.memory
  task_port             = var.port
  desired_count         = 1
  container_definitions = jsonencode([module.td_app.json_object])
  vpc_id                = data.aws_vpc.this.id
  security_group_ids    = [aws_security_group.this.id]
  subnets               = data.aws_subnets.app.ids
  elb_name              = data.aws_lb.this.name
  alb_hosts             = ["hello.*"]
  health_check_path     = "/health"
  execution_role_arn    = data.aws_iam_role.ecs.arn
  # task_policy_json      = data.aws_iam_policy_document.custom.json
  depends_on            = [
    module.build,
  ]
}
