# Get the latest Amazon OS AMI
data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.ami_name_filter]
  }
}

# Create ALB for application servers
resource "aws_lb" "app_lb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = var.tags
}

# Create ALB Target Group
resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = var.tags
}

# Create ALB Listener which forwards traffic to Target Group
resource "aws_lb_listener" "app_http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }

  tags = var.tags
}

# Create Launch Template for application servers
resource "aws_launch_template" "app_lt" {
  name          = "app-lt"
  image_id      = data.aws_ami.app_ami.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [var.app_sg_id]

  tags = var.tags
}

# Create Auto Scaling Group for application servers and bind to ALB Target Group
resource "aws_autoscaling_group" "app_asg" {
  name                 = "app-asg"
  min_size             = 2
  max_size             = 2
  desired_capacity     = 2
  vpc_zone_identifier  = var.control_subnet_ids
  target_group_arns    = [aws_lb_target_group.app_tg.arn]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }
}
