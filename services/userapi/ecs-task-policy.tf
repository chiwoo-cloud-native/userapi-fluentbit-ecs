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
      "logs:PutRetentionPolicy",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
    ]
    resources = ["*"]
  }

}
