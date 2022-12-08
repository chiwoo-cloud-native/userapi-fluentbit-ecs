locals {
  role_name   = format("%s-%s-role", local.project, local.app_name)
  policy_name = format("%s-%s-policy", local.project, local.app_name)
}

data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name = local.role_name

  assume_role_policy = data.aws_iam_policy_document.assume.json
  tags               = merge(local.tags, {
    Name = local.role_name
  })

}

# CUSTOM CodeBuild Policy
data "aws_iam_policy_document" "custom" {
  # CodeBuild
  statement {
    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages"
    ]
    resources = [
      "*"
    ]
  }

  # EC2 / SecurityGroup
  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
      "ec2:CreateNetworkInterfacePermission",
    ]
    resources = [
      "*"
    ]
  }

  # Cloudwatch
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "*"
    ]
  }

  # S3
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]
    resources = [
      "*"
    ]
  }

}

resource "aws_iam_policy" "custom" {
  name   = local.policy_name
  policy = data.aws_iam_policy_document.custom.json

  tags = merge(local.tags, {
    Name = local.policy_name
  })
}

resource "aws_iam_role_policy_attachment" "iam_policy" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.custom.arn
}

data "aws_iam_policy" "AmazonEC2ContainerRegistryPowerUser" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "iam_ecr_policy" {
  role       = aws_iam_role.this.name
  policy_arn = data.aws_iam_policy.AmazonEC2ContainerRegistryPowerUser.arn
}
