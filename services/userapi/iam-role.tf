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
  name   = local.ecs_task_policy_name
  policy = data.aws_iam_policy_document.custom.json
  tags   = merge(local.tags, {
    Name = local.ecs_task_policy_name
  })
}

resource "aws_iam_role_policy_attachment" "custom" {
  role       = aws_iam_role.task_role.name
  policy_arn = concat(aws_iam_policy.custom.*.arn, [""])[0]
}

##### you can add custom task execute policy for ecs app service
data "aws_iam_policy_document" "custom" {

  statement {
    effect  = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters"
    ]
    resources = ["arn:aws:ssm:${local.region}:${local.account_id}:parameter/symple/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = ["arn:aws:kms:${local.region}:${local.account_id}:key/${data.aws_kms_key.this.id}"]
  }
  # Cloudwatch
  statement {
    effect  = "Allow"
    actions = [
      "sts:AssumeRole",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
    ]
    resources = ["*"]
  }

}
