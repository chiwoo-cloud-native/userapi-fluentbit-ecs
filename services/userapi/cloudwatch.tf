locals {
  app_cwg_name    = format("/ecs/%s/%s", local.cluster_name, var.app_name)
  fluent_cwg_name = format("/ecs/%s/%s", local.cluster_name, local.fluentbit)
}

module "cwg_fb" {
  source            = "../../modules/cloudwatch/log-group/"
  name              = local.fluent_cwg_name
  retention_in_days = 7
  tags              = merge(local.tags, {
    Name = local.fluent_cwg_name
  })
}

module "cwg_app" {
  source            = "../../modules/cloudwatch/log-group/"
  name              = local.app_cwg_name
  retention_in_days = 7
  tags              = merge(local.tags, {
    Name = local.app_cwg_name
  })
}

module "metric_app_error" {
  source                          = "../../modules/cloudwatch/metrics/"
  name                            = "ApplicationErrorCount"
  log_group_name                  = local.app_cwg_name
  metric_transformation_namespace = format("%s/%s", local.cluster_name, var.app_name)
  pattern                         = "{ $.level=\"ERROR\" }"
  metric_transformation_name      = "ErrorCount"
  metric_transformation_value     = "1"
}


module "metric_app_warn" {
  source                          = "../../modules/cloudwatch/metrics/"
  name                            = "ApplicationWarningCount"
  log_group_name                  = local.app_cwg_name
  metric_transformation_namespace = format("%s/%s", local.cluster_name, var.app_name)
  pattern                         = "{ $.level=\"WARN\" }"
  metric_transformation_name      = "WarningCount"
  metric_transformation_value     = "1"
}

module "metric_app_info" {
  source                          = "../../modules/cloudwatch/metrics/"
  name                            = "ApplicationInfoCount"
  log_group_name                  = local.app_cwg_name
  metric_transformation_namespace = format("%s/%s", local.cluster_name, var.app_name)
  pattern                         = "{ $.level=\"INFO\" }"
  metric_transformation_name      = "InfoCount"
  metric_transformation_value     = "1"
}
