resource "aws_ami_from_instance" "seungjun_ami" {
  name               = "seungjun-ami"
  source_instance_id = aws_instance.seungjun_weba.id
  depends_on = [
    aws_instance.seungjun_weba
  ]
}
#===================launch configuration=========================
resource "aws_launch_configuration" "seungjun_lacf" {
  name_prefix          = "seungjun-web"
  image_id             = aws_ami_from_instance.seungjun_ami.id
  instance_type        = "t2.micro"
  iam_instance_profile = "admin-role"
  security_groups      = [aws_security_group.seungjun_websg.id]
  key_name             = "tf-key"
  user_data            = <<-EOF
                #!/bin/bash
                systemctl start httpd
                systemctl enable httpd
                EOF
  lifecycle {
    create_before_destroy = true
  }
}
#=====================auto scaling group============================
resource "aws_placement_group" "seungjun_pg" {
  name     = "seungjun-pg"
  strategy = "cluster"
}

resource "aws_autoscaling_group" "seungjun_atsg" {
  name                      = "seungjun-atsg"
  min_size                  = 2
  max_size                  = 8
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  launch_configuration      = aws_launch_configuration.seungjun_lacf.name
  vpc_zone_identifier       = [aws_subnet.seungjun_pub[0].id, aws_subnet.seungjun_pub[1].id]

}
#=======================autoscaling attachment===============================
resource "aws_autoscaling_attachment" "seungjun_atatt" {
  autoscaling_group_name = aws_autoscaling_group.seungjun_atsg.id
  alb_target_group_arn   = aws_lb_target_group.seungjun_lbtg.arn
}
