locals {
  region                   = "ap-northeast-2"
  name_prefix              = "demo-an2d"
  cluster_name             = "demo"
  app_name                 = "order"
  app_repository_uri       = "370166107047.dkr.ecr.ap-northeast-2.amazonaws.com/demo-an2d-order-ecr"
  fluentbit_repository_uri = "370166107047.dkr.ecr.ap-southeast-1.amazonaws.com/symple-ase1d-fluentbit-ecr"
  cpu                      = "512"
  memory                   = "1024"
  port                     = "8080"
}

module "td_app" {
  source          = "../../modules/ecss/definitions/"
  app_name        = local.app_name
  name_prefix     = local.name_prefix
  container_image = local.app_repository_uri
  cpu             = local.cpu
  memory          = local.memory
  port_mappings   = [
    {
      containerPort = local.port
      hostPort      = local.port
      protocol      = "tcp"
    }
  ]
  environment = [
    {
      name  = "SPRING_PROFILES_ACTIVE"
      value = "dev"
    }
  ]
  mount_points = [
    {
      containerPath = "/var/log/myapp"
      sourceVolume  = "myapp"
      readOnly      = false
    }
  ]
  log_configuration = {
    "logDriver" = "awsfirelens"
    "options"   = {
      Name              = "cloudwatch"
      region            = local.region
      log_group_name    = "/ecs/containerinsights/${local.cluster_name}/apps"
      auto_create_group = true
      log_stream_name   = local.app_name
    }
  }

}

module "td_fb" {
  source             = "../../modules/ecss/definitions/"
  container_image    = local.fluentbit_repository_uri
  app_name           = "fluentbit"
  name_prefix        = local.name_prefix
  memory_reservation = 50
  mount_points       = [
    {
      containerPath = "/var/log/myapp"
      sourceVolume  = "myapp"
      readOnly      = true
    }
  ]
  environment = [
    {
      name  = "ECS_CLUSTER_NAME"
      value = local.cluster_name
    },
    {
      name  = "ECS_REGION"
      value = local.region
    },
    {
      name  = "ECS_APP_NAME"
      value = local.app_name
    },
    {
      name  = "LOG_FILEPATH"
      value = "/var/log/myapp/app.log"
    }
  ]
  log_configuration = {
    "logDriver" = "awslogs"
    "options"   = {
      "awslogs-group"         = "firelens-container"
      "awslogs-region"        = local.region
      "awslogs-stream-prefix" = "firelens"
      "awslogs-create-group"  = "true"
    }
  }
  firelens_configuration = {
    "type"    = "fluentbit"
    "options" = {
      "enable-ecs-log-metadata" = "false"
    }
  }
  volumes_from = [
  ]
}

locals {
  container_definitions = jsonencode([module.td_app.json_object, module.td_fb.json_object])
}

output "container_definitions" {
  value = local.container_definitions
}
