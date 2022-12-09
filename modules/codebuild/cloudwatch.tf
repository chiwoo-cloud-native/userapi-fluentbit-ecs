locals {
  cw_group_name = format("/codebuild/%s", local.full_name)
}

resource aws_cloudwatch_log_group "this" {
  name              = local.cw_group_name
  retention_in_days = var.retention_in_days
  tags              = merge(local.tags, {
    Name = local.cw_group_name
  })
}

/*
module "log_group" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-group"
  version = "~> 3.0"

  name              = "my-app"
  retention_in_days = 120
}
*/
