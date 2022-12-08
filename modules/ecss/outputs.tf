output "ecs_cluster_id" {
  description = "ID of the ECS Cluster"
  value       = data.aws_ecs_cluster.this.id
}

output "ecs_cluster_name" {
  description = "The name of the ECS Cluster"
  value       = var.cluster_name
}

output "ecs_task_definition_id" {
  description = "ID of the ECS Task Definition"
  value       = concat(aws_ecs_task_definition.this.*.id, [""])[0]
}

output "ecs_task_definition_family" {
  description = "ID of the ECS Task Definition"
  value       = concat(aws_ecs_task_definition.this.*.family, [""])[0]
}

output "ecs_task_definition_revision" {
  description = "ID of the ECS Task Definition"
  value       = concat(aws_ecs_task_definition.this.*.revision, [""])[0]
}

output "ecs_service_id" {
  description = "ID of the ECS Application Service"
  value       = concat(aws_ecs_service.this.*.id, [""])[0]
}

output "ecs_service_name" {
  description = "The name of the ECS Application Service"
  value       = local.service_name
}

output "ecs_container_name" {
  description = "The name of the ECS Application Container"
  value       = local.container_name
}

output "target_group_arn" {
  value = concat(aws_lb_target_group.blue.*.arn, [""])[0]
}

# var.create_listener ? 0 : 1
# front_alb_listener_arn = concat(data.aws_lb_listener.front.*.arn, [""])[0]
# back_alb_listener_arn  = concat(aws_lb_listener.this.*.arn, [""])[0]
output "elb_listener_arn" {
  value = local.elb_listener_arn
}

output "code_deploy_name" {
  description = "CodeDeploy name"
  value       = local.code_deploy_name
}

output "code_deploy_grp_name" {
  description = "CodeDeploy Group name"
  value       = local.code_deploy_grp_name
}
