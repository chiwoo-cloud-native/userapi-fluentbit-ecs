locals {
  task_definition_name = format("%s-td", local.app_name)
}

resource "aws_ecs_task_definition" "this" {
  count = var.delete_service ? 0 : 1

  family                   = local.task_definition_name
  requires_compatibilities = var.requires_compatibilities
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = var.execution_role_arn
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  container_definitions    = var.container_definitions # jsonencode(local.container_definition)

  dynamic "volume" {
    for_each = var.volume_name != null ? ["true"] : []
    content {
      name = var.volume_name
    }
  }

  tags = merge(local.tags, var.tags, {
    Name = local.task_definition_name
  })

}
