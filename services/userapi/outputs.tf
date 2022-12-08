output "ecs_cluster_id" {
  value = module.app.ecs_cluster_id
}

output "ecs_cluster_name" {
  value = module.app.ecs_cluster_name
}

output "ecs_service_name" {
  value = module.app.ecs_service_name
}

output "kms_key_id" {
  value = data.aws_kms_key.this.id
}
