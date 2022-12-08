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
