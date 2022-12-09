# app ECR 서비스 구성
module "ecr_app" {
  source     = "../../modules/ecr/"
  context    = module.ctx.context
  app_name   = var.app_name
}

# ECR 서비스 구성
module "ecr_fb" {
  source     = "../../modules/ecr/"
  context    = module.ctx.context
  app_name   = "fluentbit"
}
