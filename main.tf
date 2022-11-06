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
    values = ["x86_64"]
  }
  # ARM is allowed, but does not support SRT ingest
}

# AMS EC2 Instance
resource "aws_instance" "ant_media_ec2" {
  count         = var.instances
  ami           = data.aws_ami.ant_media_ami.id
  instance_type = var.instance_type
  # ARM is not supported in all AZ
  availability_zone = element(var.az, count.index)

  network_interface {
    network_interface_id = element(aws_network_interface.ant_media_interface[*].id, count.index)
    device_index         = 0
  }

  tags = {
    CreatedBy    = var.creator
    AppName      = "ant-media-server"
    ResourceName = format("%s %s", var.instance_name, "${count.index + 1}")
  }
}

resource "aws_network_interface" "ant_media_interface" {
  count           = var.instances
  subnet_id       = element(aws_subnet.ant_media_private_subnet[*].id, count.index)
  private_ips     = var.instance_private_ip
  security_groups = [aws_security_group.ant_media_ec2_sg.id]

  tags = {
    CreatedBy    = var.creator
    AppName      = "ant-media-server"
    ResourceName = format("%s %s", "Network interface", "${count.index + 1}")
  }
}

# EC2 security group
resource "aws_security_group" "ant_media_ec2_sg" {
  name        = "Ant Media Server Standalone"
  description = "AMS SG with single-IP access"
  vpc_id      = aws_vpc.ant_media_vpc.id

  ingress {
    description     = "HTTP"
    from_port       = 5080
    to_port         = 5080
    protocol        = "TCP"
    # Need to allow TCP health check from NLB
    # security_groups = [aws_security_group.ant_media_alb_sg.id]
    cidr_blocks = var.public_subnet_cidrs
  }

  ingress {
    description     = "HTTPS"
    from_port       = 5443
    to_port         = 5443
    protocol        = "TCP"
    security_groups = [aws_security_group.ant_media_alb_sg.id]
  }

  ingress {
    description = "SRT"
    from_port   = 4200
    to_port     = 4200
    protocol    = "UDP"
    cidr_blocks = var.public_subnet_cidrs
  }

    ingress {
    description = "RTMP"
    from_port   = 1935
    to_port     = 1935
    protocol    = "TCP"
    cidr_blocks = var.public_subnet_cidrs
  }

  # Required for low latency WebRTC
  # ingress {
  #   description = "WebRTC and RTSP"
  #   from_port   = 5000
  #   to_port     = 65000
  #   protocol    = "udp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  tags = {
    CreatedBy    = var.creator
    AppName      = "ant-media-server"
    ResourceName = "AMS EC2 SG"
  }
}