# --------------------------------------------------
# ロードバランサー
# --------------------------------------------------
resource "aws_lb" "lb_output" {
  name                       = "lb-output"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.security_group_output.id] // TODO: ECS用のセキュリティグループなので適当にする必要がある
  subnets                    = [aws_subnet.subnet_public_1a_output.id, aws_subnet.subnet_public_1c_output.id]
  enable_deletion_protection = false

  tags = {
    Name = "tag-output"
  }
}

resource "aws_lb_listener" "lb_listener_output" {
  load_balancer_arn = aws_lb.lb_output.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group_output.arn
  }
}

resource "aws_lb_target_group" "lb_target_group_output" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_output.id
  target_type = "ip" # Fargateの場合、IPアドレスでターゲットを登録
}
