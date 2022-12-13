locals {
  project      = module.ctx.project
  name_prefix  = module.ctx.name_prefix
  region       = module.ctx.region
  tags         = module.ctx.tags
  cluster_name = "${local.name_prefix}-demo-ecs"
  elb_name     = format("%s-%s", local.name_prefix, "pub-alb")
  account_id   = data.aws_caller_identity.current.account_id
  fluentbit    = "fluentbit"
}

module "ctx" {
  source  = "../../modules/context/"
  context = var.context
}

module "td_fb" {
  source          = "../../modules/ecss/definitions/"
  container_image = format("%s:latest", module.ecr_fb.repository_url)
  app_name        = local.fluentbit
  name_prefix     = local.name_prefix
  environment     = [
    {
      name  = "AWS_REGION"
      value = local.region
    },
    {
      name  = "ECS_CLUSTER_NAME"
      value = local.cluster_name
    },
    {
      name  = "ECS_APP_NAME"
      value = var.app_name
    },
    {
      name  = "LOG_FILEPATH"
      value = "/var/log/myapp/app.log"
    }
  ]
  log_configuration = {
    logDriver = "awslogs"
    options   = {
      "awslogs-group"         = module.cwg_fb.cloudwatch_log_group_name
      "awslogs-region"        = local.region
      "awslogs-stream-prefix" = local.fluentbit
      "awslogs-create-group"  = "true"
    }
  }
  container_depends_on = [
    {
      containerName = module.td_app.container_name
      condition     = "START"
    }
  ]
  mount_points = [
    {
      sourceVolume  = "myapp"
      containerPath = "/var/log/myapp"
      readOnly      = true
    }
  ]
}


module "td_app" {
  source          = "../../modules/ecss/definitions/"
  app_name        = var.app_name
  name_prefix     = local.name_prefix
  container_image = format("%s:latest", module.ecr_app.repository_url)
  cpu             = var.cpu
  memory          = var.memory
  port_mappings   = [
    {
      containerPort = var.port
      hostPort      = var.port
      protocol      = "tcp"
    }
  ]
  environment = [
    {
      name  = "SPRING_PROFILES_ACTIVE"
      value = "dev",
    },
  ]
  mount_points = [
    {
      sourceVolume  = "myapp"
      containerPath = "/var/log/myapp"
      readOnly      = false
    }
  ]
}

module "app" {
  source                = "../../modules/ecss/"
  context               = module.ctx.context
  disabled_code_deploy  = true
  cluster_name          = local.cluster_name
  app_name              = var.app_name
  task_cpu              = var.cpu
  task_memory           = var.memory
  task_port             = var.port
  desired_count         = 1
  container_definitions = jsonencode([module.td_app.json_object, module.td_fb.json_object])
  volume_name           = "myapp"
  vpc_id                = data.aws_vpc.this.id
  security_group_ids    = [aws_security_group.this.id]
  subnets               = data.aws_subnets.app.ids
  elb_name              = local.elb_name
  listener_port         = 443
  alb_hosts             = ["user.*"]
  health_check_path     = "/health"
  execution_role_arn    = data.aws_iam_role.ecs.arn
  task_policy_json      = data.aws_iam_policy_document.custom.json
  depends_on            = [
    module.build_app,
    module.build_fb
  ]
}
