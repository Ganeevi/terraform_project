# Creating a Launch Template
resource "aws_launch_template" "Web_launch_template" {
  tags                 = { Name = "Web_launch_template" }
  name                 = "Web_launch_template"
  image_id             = "ami-05839228e96a46460"
  instance_type        = "t2.micro"
  key_name             = "Mumbai"
  security_group_names = [aws_security_group.All-Open.id]
}

resource "aws_alb_target_group" "Web-target-group" {
  name             = "Web-target-group"
  port             = 80
  protocol         = "HTTP"
  vpc_id           = aws_vpc.myVPC.id
  ip_address_type  = "ipv4"
  protocol_version = "HTTP1"

  health_check {
    protocol            = "HTTP"
    path                = "/"
    port                = 80
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb" "myWebALB" {
  name            = "myWebALB"
  internal        = false
  security_groups = [aws_security_group.Web.id]
  subnets         = [aws_subnet.Public-Subnet-1.id, aws_subnet.Public-Subnet-2.id]

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_alb_target_group_attachment" "Web-target-group_att" {
  target_group_arn = aws_alb_target_group.Web-target-group.arn
  target_id        = aws_instance.Web-Server.id
  depends_on       = [aws_alb.myWebALB]
  port             = 80

  lifecycle {
    create_before_destroy = true
  }
}


//http listener
resource "aws_alb_listener" "alb_http_listener" {
  load_balancer_arn = aws_alb.myWebALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.Web-target-group.arn
    type             = "forward"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "rule_b" {
  listener_arn = aws_alb_listener.alb_http_listener.arn
  priority     = 60

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.Web-target-group.arn
  }

  condition {
    path_pattern {
      values = ["/images*"]
    }
  }
}