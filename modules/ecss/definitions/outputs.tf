output "container_name" {
  value = local.container_name
}

output "json_map_encoded_list" {
  description = "JSON string encoded list of container definitions for use with other terraform resources such as aws_ecs_task_definition"
  value       = "[${local.json_map}]"
}

output "json_map_encoded" {
  description = "JSON string encoded container definitions for use with other terraform resources such as aws_ecs_task_definition"
  value       = local.json_map
}

output "json_object" {
  description = "JSON object container definition"
  value       = local.json_object
}

output "json_map_object" {
  description = "JSON map decoded container definition"
  value       = jsondecode(local.json_map)
}

output "sensitive_json_map_encoded_list" {
  description = "JSON string encoded list of container definitions for use with other terraform resources such as aws_ecs_task_definition (sensitive)"
  value       = "[${local.json_map}]"
  sensitive   = true
}

output "sensitive_json_map_encoded" {
  description = "JSON string encoded container definitions for use with other terraform resources such as aws_ecs_task_definition (sensitive)"
  value       = local.json_map
  sensitive   = true
}

output "sensitive_json_map_object" {
  description = "JSON map decoded container definition (sensitive)"
  value       = jsondecode(local.json_map)
  sensitive   = true
}
