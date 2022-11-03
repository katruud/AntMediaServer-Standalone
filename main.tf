provider "aws" {
  region = var.region
}

# AMS AMI Search
data "aws_ami" "ant_media_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["AntMedia-AWS-Marketplace-EE-*"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}

# AMS EC2 Instance
resource "aws_instance" "ant_media_ec2" {
  count                  = var.instances
  ami                    = data.aws_ami.ant_media_ami.id
  instance_type          = var.instance_type
  # ARM is not supported in all AZ
  availability_zone = element(var.az, count.index)

  network_interface {
    network_interface_id = element(aws_network_interface.ant_media_interface[*].id, count.index)
    device_index         = 0
  }

  tags = {
    Name = format("%s %s", var.instance_name,"${count.index + 1}")
  }
}

resource "aws_network_interface" "ant_media_interface" {
  count = var.instances
  subnet_id   = element(aws_subnet.ant_media_private_subnet[*].id, count.index)
  private_ips = var.instance_private_ip
  security_groups = [aws_security_group.ant_media_sg.id]

  tags = {
    Name = "primary_network_interface"
  }
}

# Load balancer for HTTP
resource "aws_lb" "ant_media_lb" {
  name               = "ant-media-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ant_media_sg.id]
  subnets            = [for subnet in aws_subnet.ant_media_public_subnet : subnet.id]

  tags = {
    Name = "Ant media application LB"
  }
}

# Load balancer for RTMP
resource "aws_lb" "ant_media_lb" {
  name               = "ant-media-lb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.ant_media_sg.id]
  subnets            = [for subnet in aws_subnet.ant_media_public_subnet : subnet.id]

  tags = {
    Name = "Ant media network LB"
  }
}

# Security Group
# Access IP is our IP for dev https://stackoverflow.com/questions/46763287
data "http" "myip" {
  url = "http://ipv4.icanhazip.com/ip"
}
locals {
  my_ip = ["${chomp(data.http.myip.response_body)}/32"]
  access_cidr = concat(var.access_ips,local.my_ip)
}

resource "aws_security_group" "ant_media_sg" {
  name        = "Ant Media Server Standalone"
  description = "AMS SG with single-IP access"
  vpc_id = aws_vpc.ant_media_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 5080
    to_port     = 5080
    protocol    = "tcp"
    cidr_blocks = local.access_cidr
  }

  ingress {
    description = "HTTPS"
    from_port   = 5443
    to_port     = 5443
    protocol    = "tcp"
    cidr_blocks = local.access_cidr
  }

  ingress {
    description = "RTMP"
    from_port   = 1935
    to_port     = 1935
    protocol    = "tcp"
    cidr_blocks = local.access_cidr
  }

  ingress {
    description = "RTSP"
    from_port   = 5554
    to_port     = 5554
    protocol    = "tcp"
    cidr_blocks = local.access_cidr
  }

  ingress {
    description = "SRT"
    from_port   = 4200
    to_port     = 4200
    protocol    = "tcp"
    cidr_blocks = local.access_cidr
  }

  ingress {
    description = "WebRTC and RTSP"
    from_port   = 5000
    to_port     = 65000
    protocol    = "udp"
    cidr_blocks = local.access_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ant media security group"
  }
}
