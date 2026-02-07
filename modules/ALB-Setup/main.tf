# Create the ALB
resource "aws_lb" "my-alb" {
  name               = "my-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = [var.private_subnet_id_01, var.private_subnet_id_02]

  enable_deletion_protection = false

  tags = {
    Name = "my-alb"
  }
}

# Create an ALB Target Group

resource "aws_lb_target_group" "alb-target-group" {
  name     = "alb-target-group"
  target_type = "lambda"
  
  tags = {
    Name = "alb-target-group"
  }
}

resource "aws_lambda_permission" "allow_alb" {
  statement_id  = "AllowExecutionFromALB"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.alb-target-group.arn
}

resource "aws_lb_target_group_attachment" "lambda_attach" {
  target_group_arn = aws_lb_target_group.alb-target-group.arn
  target_id        = var.lambda_arn

  depends_on = [aws_lambda_permission.allow_alb]
}

# Read an ACM Certificate in USEast1 (N. Virginia) region
data "aws_acm_certificate" "cert" {
  domain   = "*.cloudlab-km.com"
  statuses = ["ISSUED"]
}

# Create an ALB Listener
resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.my-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn = data.aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-target-group.arn
  }

  tags = {
    Name = "alb-listener"
  }
}