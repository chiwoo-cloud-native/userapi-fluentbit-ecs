locals {
  project     = var.context.project
  name_prefix = var.context.name_prefix
  tags        = var.context.tags
  region      = var.context.region
  app_name    = var.app_name
  full_name   = format("%s-%s", local.name_prefix, local.app_name)
  build_name  = format("%s-build", local.full_name)
}

resource "aws_codebuild_source_credential" "this" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = data.aws_ssm_parameter.github.value
}

resource "aws_codebuild_project" "this" {
  name           = local.build_name
  description    = format("%s", local.app_name)
  build_timeout  = 10 # build min
  queued_timeout = 60
  service_role   = aws_iam_role.this.arn
  badge_enabled  = false

  artifacts {
    type = "NO_ARTIFACTS" # CODEPIPELINE, NO_ARTIFACTS, S3
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  #  cache {
  #    type     = "S3"
  #    location = data.aws_s3_bucket.this.bucket
  #  }

  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = data.aws_subnets.app.ids
    security_group_ids = [
      aws_security_group.this.id,
    ]
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.environment_image
    type                        = var.environment_type
    privileged_mode             = var.privileged_mode
    image_pull_credentials_type = var.image_pull_credentials_type
    environment_variable {
      name  = "REPOSITORY_URI"
      value = var.repository_url
    }
    environment_variable {
      name  = "CONTAINER_NAME"
      value = var.app_name
    }
    environment_variable {
      name  = "CONTAINER_PORT"
      value = var.container_port
    }
    environment_variable {
      name  = "HEALTH_CHECK_PATH"
      value = var.health_check_path
    }
  }

  source {
    type            = var.source_type
    location        = var.source_location
    git_clone_depth = 1
    buildspec       = var.buildspec
  }
  # source_version = var.build_branch

  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.this.name
      stream_name = "codebuild/${local.app_name}"
    }
  }

  tags = merge(local.tags, {
    Name = local.build_name
  })

  depends_on = [
    aws_codebuild_source_credential.this,
    aws_iam_role_policy_attachment.iam_ecr_policy,
    aws_security_group.this,
    aws_cloudwatch_log_group.this,
  ]

}

resource "null_resource" "build" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
WAIT_FOR_BUILD_ID=$(aws codebuild start-build --project-name ${aws_codebuild_project.this.name} --region ${local.region} | jq --raw-output '.build.id')
echo " - WAIT_FOR_BUILD_ID: $${WAIT_FOR_BUILD_ID}"
BUILD_STATUS="IN_PROGRESS"

while [ "$${BUILD_STATUS}" = "IN_PROGRESS" ]
do
  BUILD_STATUS=$(aws codebuild batch-get-builds --ids $${WAIT_FOR_BUILD_ID} --region ap-southeast-1 --query 'builds[0].buildStatus' --output text);
  echo " - CODEBUILD_STATUS: $${BUILD_STATUS}"; sleep 5;
done

EOF
  }
  depends_on = [
    aws_codebuild_project.this
  ]
}
