data "aws_subnets" "app" {
  filter {
    name   = "vpc-id"
    values = [ var.vpc_id ]
  }

  filter {
    name   = "tag:Name"
    values = [ format("%s-app*", local.name_prefix) ]
  }
}

data "aws_ssm_parameter" "github" {
  name            = var.source_token_parameter_store
  with_decryption = true
}

