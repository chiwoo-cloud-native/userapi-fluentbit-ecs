# CodeBuild for app
module "build_app" {
  source                       = "../../modules/codebuild/"
  context                      = module.ctx.context
  app_name                     = var.app_name
  vpc_id                       = data.aws_vpc.this.id
  repository_url               = module.ecr_app.repository_url
  source_token_parameter_store = var.source_token_parameter_store
  source_location              = var.source_location
  buildspec                    = "cicd/dev/buildspec.yaml"
}

# CodeBuild for fluentbit
module "build_fb" {
  source                       = "../../modules/codebuild/"
  context                      = module.ctx.context
  app_name                     = "fluentbit"
  vpc_id                       = data.aws_vpc.this.id
  repository_url               = module.ecr_fb.repository_url
  source_token_parameter_store = var.source_token_parameter_store
  source_location              = var.source_location
  buildspec                    = "cicd/fluentbit/buildspec.yaml"
}
