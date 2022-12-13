resource "aws_cloudwatch_log_metric_filter" "this" {

  name           = var.name
  pattern        = var.pattern
  log_group_name = var.log_group_name

  metric_transformation {
    namespace     = var.metric_transformation_namespace
    name          = var.metric_transformation_name
    value         = var.metric_transformation_value
    default_value = var.metric_transformation_default_value
    unit          = var.metric_transformation_unit
  }
}
