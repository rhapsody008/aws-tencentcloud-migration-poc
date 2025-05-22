resource "aws_lb" "zy_test_aws_alb" {
  name_prefix        = var.aws_resource_prefix
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.zy_test_aws_sg.id]
  subnets            = [aws_subnet.zy_test_aws_subnet1.id, aws_subnet.zy_test_aws_subnet2.id]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "zy_test_aws_tg" {
  name_prefix = var.aws_resource_prefix
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.zy_test_aws_vpc.id
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "zy_test_aws_https_listener" {
  load_balancer_arn = aws_lb.zy_test_aws_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.zy_test_aws_tg.arn
  }
}
