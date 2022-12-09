locals {
  elb_listener_arn = var.create_listener ? concat(aws_lb_listener.this.*.arn, [""])[0] : concat(data.aws_lb_listener.this.*.arn, [""])[0]
}

# Create listener to ELB
resource "aws_lb_listener" "this" {
  count             = var.create_listener ? 1 : 0
  load_balancer_arn = data.aws_lb.this.arn
  protocol          = local.listener_protocol
  port              = var.listener_port

  default_action {
    type             = "forward"
    target_group_arn = concat(aws_lb_target_group.blue.*.arn, [""])[0]
  }

  lifecycle {
    ignore_changes = [default_action]
  }
}

# Add listener rule to ALB
resource "aws_lb_listener_rule" "this" {
  count        = var.create_listener ? 0 : 1
  listener_arn = local.elb_listener_arn

  action {
    type             = "forward"
    target_group_arn = concat(aws_lb_target_group.blue.*.arn, [""])[0]
  }

  dynamic "condition" {
    for_each = length(var.alb_hosts) > 0 ? [1] : []
    content {
      host_header {
        values = var.alb_hosts
      }
    }
  }

  dynamic "condition" {
    for_each = length(var.alb_paths) > 0 ? [1] : []
    content {
      path_pattern {
        values = var.alb_paths
      }
    }
  }

  lifecycle {
    ignore_changes = [action]
  }
}
