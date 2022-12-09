locals {
  ecs_task_role_name   = format("%s%s", local.project, replace(title( format("%s-EcsTaskRole", var.app_name) ), "-", "" ))
  ecs_task_policy_name = format("%s%s", local.project, replace(title( format("%s-EcsTaskPolicy", var.app_name) ), "-", "" ))
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_role" {
  name               = local.ecs_task_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = merge(local.tags, { Name = local.ecs_task_role_name })
}

resource "aws_iam_role_policy_attachment" "ecsCmdExecPolicy" {
  role       = aws_iam_role.task_role.name
  policy_arn = "arn:aws:iam::${local.account_id}:policy/AmazonECSCommandExecutionPolicy"
}

resource "aws_iam_policy" "custom" {
  count  = var.task_policy_json == null ? 0 : 1
  name   = local.ecs_task_policy_name
  policy = var.task_policy_json
  tags   = merge(local.tags, {
    Name = local.ecs_task_policy_name
  })
}

resource "aws_iam_role_policy_attachment" "custom" {
  count      = var.task_policy_json == null ? 0 : 1
  role       = aws_iam_role.task_role.name
  policy_arn = concat(aws_iam_policy.custom.*.arn, [""])[0]
}
