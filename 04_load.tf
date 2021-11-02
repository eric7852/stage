resource "aws_lb" "seungjun_lb" {
  name               = "seungjun-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.seungjun_websg.id]
  subnets            = [aws_subnet.seungjun_pub[0].id, aws_subnet.seungjun_pub[1].id]

  tags = {
    Name = "seungjun-alb"
  }
}
#==========================load balance target group=========================
resource "aws_lb_target_group" "seungjun_lbtg" {
  name     = "seungjun-lbtg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.seungjun_vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 5
    matcher             = "200"
    path                = "/health.html"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 2
    unhealthy_threshold = 2
  }
}
#=============================listener====================================
resource "aws_lb_listener" "seungjun_lblist" {
  load_balancer_arn = aws_lb.seungjun_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.seungjun_lbtg.arn

  }
}
#=========================target group attachment===========================
resource "aws_lb_target_group_attachment" "seungjun_lbtg_att" {
  target_group_arn = aws_lb_target_group.seungjun_lbtg.arn
  target_id        = aws_instance.seungjun_weba.id
  port             = 80
}


