# app ECR 서비스 구성
module "ecr" {
  source   = "../../modules/ecr/"
  context  = module.ctx.context
  app_name = var.app_name
}

# CodeBuild for app
module "build" {
  source                       = "../../modules/codebuild/"
  context                      = module.ctx.context
  vpc_id                       = data.aws_vpc.this.id
  repository_url               = module.ecr.repository_url
  source_token_parameter_store = var.source_token_parameter_store
  source_location              = var.source_location
  buildspec                    = "cicd/hello/buildspec.yaml"
  app_name                     = var.app_name
  container_port               = var.port
  health_check_path            = "/health"
}
