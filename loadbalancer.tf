# NLB
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "ant_media_nlb" {
  name               = "ant-media-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [for subnet in aws_subnet.ant_media_public_subnet : subnet.id]

  tags = {
    CreatedBy    = var.creator
    AppName      = "ant-media-server"
    ResourceName = "AMS NLB"
  }
}

# ALB Target group
resource "aws_lb_target_group" "ant_media_target_alb" {
  name        = "ant-media-alb-target"
  target_type = "alb"
  port        = "5080"
  protocol    = "TCP"
  vpc_id      = aws_vpc.ant_media_vpc.id
}

# NLB Listeners
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "ant_media_nlb_listener_http" {
  load_balancer_arn = aws_lb.ant_media_nlb.arn
  port              = "5080"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ant_media_target_alb.arn
  }
}
resource "aws_lb_listener" "ant_media_nlb_listener_https" {
  load_balancer_arn = aws_lb.ant_media_nlb.arn
  port              = "5443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ant_media_target_alb.arn
  }
}

resource "aws_lb_listener" "ant_media_nlb_listener_srt" {
  load_balancer_arn = aws_lb.ant_media_nlb.arn
  port              = "4200"
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ant_media_target_ec2_udp.arn
  }
}
  resource "aws_lb_listener" "ant_media_nlb_listener_rtmp" {
  load_balancer_arn = aws_lb.ant_media_nlb.arn
  port              = "1935"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ant_media_target_ec2_tcp.arn
  }
}

# NLB target group attach
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
resource "aws_lb_target_group_attachment" "attach_alb" {
  target_group_arn = aws_lb_target_group.ant_media_target_alb.arn
  target_id        = aws_lb.ant_media_alb.arn
}

# ALB
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "ant_media_alb" {
  name               = "ant-media-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ant_media_alb_sg.id]
  subnets            = [for subnet in aws_subnet.ant_media_public_subnet : subnet.id]

  tags = {
    CreatedBy    = var.creator
    AppName      = "ant-media-server"
    ResourceName = "AMS ALB"
  }
}

# ALB SG
resource "aws_security_group" "ant_media_alb_sg" {
  name   = "Ant Media Server ALB SG"
  vpc_id = aws_vpc.ant_media_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 5080
    to_port     = 5080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 5443
    to_port     = 5443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    CreatedBy    = var.creator
    AppName      = "ant-media-server"
    ResourceName = "AMS ALB SG"
  }
}

resource "aws_security_group_rule" "egress_alb_http" {
  security_group_id        = aws_security_group.ant_media_alb_sg.id
  from_port                = 5080
  to_port                  = 5080
  protocol                 = "tcp"
  type                     = "egress"
  source_security_group_id = aws_security_group.ant_media_ec2_sg.id
}

resource "aws_security_group_rule" "egress_alb_https" {
  security_group_id        = aws_security_group.ant_media_alb_sg.id
  from_port                = 5443
  to_port                  = 5443
  protocol                 = "tcp"
  type                     = "egress"
  source_security_group_id = aws_security_group.ant_media_ec2_sg.id
}

# EC2 Target group
# https://github.com/kundusonotes/add-aws-elb-ec2-terraform/blob/add-elb/
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "ant_media_target_ec2" {
  name     = "ant-media-ec2-target"
  port     = 5080
  protocol = "HTTP"
  vpc_id   = aws_vpc.ant_media_vpc.id
  health_check {
    enabled           = true
    healthy_threshold = 3
    interval          = 10
    matcher           = 200
    path              = "/"
    # "/liveness"
    port                = 5080
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 2
  }

  tags = {
    CreatedBy    = var.creator
    AppName      = "ant-media-server"
    ResourceName = "AMS target group"
  }
}

# ALB target group attach
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
resource "aws_alb_target_group_attachment" "attach_ec2" {
  count            = length(aws_instance.ant_media_ec2)
  target_group_arn = aws_lb_target_group.ant_media_target_ec2.arn
  target_id        = aws_instance.ant_media_ec2[count.index].id
}

# EC2 UDP Target group
# https://github.com/kundusonotes/add-aws-elb-ec2-terraform/blob/add-elb/
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "ant_media_target_ec2_udp" {
  name     = "ant-media-ec2-udp-target"
  port     = 4200
  protocol = "UDP"
  vpc_id   = aws_vpc.ant_media_vpc.id

  health_check {
    enabled           = true
    protocol            = "TCP"
    port                = 5080
  }

  tags = {
    CreatedBy    = var.creator
    AppName      = "ant-media-server"
    ResourceName = "AMS UDP target group"
  }
}

# UDP target group attach
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
resource "aws_alb_target_group_attachment" "attach_ec2_udp" {
  count            = length(aws_instance.ant_media_ec2)
  target_group_arn = aws_lb_target_group.ant_media_target_ec2_udp.arn
  target_id        = aws_instance.ant_media_ec2[count.index].id
}

# EC2 TCP Target group
# https://github.com/kundusonotes/add-aws-elb-ec2-terraform/blob/add-elb/
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "ant_media_target_ec2_tcp" {
  name     = "ant-media-ec2-tcp-target"
  port     = 1935
  protocol = "TCP"
  vpc_id   = aws_vpc.ant_media_vpc.id

  health_check {
    enabled           = true
    protocol            = "TCP"
    port                = 5080
  }

  tags = {
    CreatedBy    = var.creator
    AppName      = "ant-media-server"
    ResourceName = "AMS TCP target group"
  }
}

# TCP target group attach
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
resource "aws_alb_target_group_attachment" "attach_ec2_tcp" {
  count            = length(aws_instance.ant_media_ec2)
  target_group_arn = aws_lb_target_group.ant_media_target_ec2_tcp.arn
  target_id        = aws_instance.ant_media_ec2[count.index].id
}

# ALB Listeners
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "ant_media_alb_listener_http" {
  load_balancer_arn = aws_lb.ant_media_alb.arn
  port              = "5080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ant_media_target_ec2.arn
  }
}
resource "aws_lb_listener" "ant_media_alb_listener_https" {
  load_balancer_arn = aws_lb.ant_media_alb.arn
  port              = "5443"
  protocol          = "HTTPS"
  certificate_arn   = var.certificate

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ant_media_target_ec2.arn
  }
}
