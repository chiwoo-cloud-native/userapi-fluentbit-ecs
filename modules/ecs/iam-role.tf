locals {
  ecs_task_role_name          = "${var.context.project}EcsTaskExecutionRole"
  ecs_task_custom_policy_name = "${var.context.project}EcsTaskCustomPolicy"
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = local.ecs_task_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
  tags               = merge(    var.context.tags, {
    Name = local.ecs_task_role_name
  })
}

data "aws_iam_policy" "ecs_task_execution_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = concat(aws_iam_role.ecs_task_execution_role.*.name, [""])[0]
  policy_arn = concat(data.aws_iam_policy.ecs_task_execution_policy.*.arn, [""])[0]
}

##### custom policy

data "aws_iam_policy_document" "custom" {

  # Cloudwatch
  statement {
    effect  = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["*"]
  }

}

resource "aws_iam_policy" "custom" {
  name   = local.ecs_task_custom_policy_name
  policy = data.aws_iam_policy_document.custom.json
  tags   = merge(var.context.tags, {
    Name = local.ecs_task_custom_policy_name
  })
}

resource "aws_iam_role_policy_attachment" "custom" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.custom.arn
}

