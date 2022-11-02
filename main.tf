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
  ami                    = data.aws_ami.ant_media_ami.id
  instance_type          = var.instance_type
  # ARM is not supported in all AZ
  availability_zone = var.az

  network_interface {
    network_interface_id = aws_network_interface.ant_media_interface.id
    device_index         = 0
  }

  tags = {
    Name = var.instance_name
  }
}

resource "aws_network_interface" "ant_media_interface" {
  subnet_id   = aws_subnet.ant_media_subnet.id
  private_ips = [var.instance_private_ip]
  security_groups = [aws_security_group.ant_media_sg.id]

  tags = {
    Name = "primary_network_interface"
  }
}

# Security Group
# Access IP is our IP for dev https://stackoverflow.com/questions/46763287
locals {
  access_ip = "${chomp(data.http.myip.response_body)}/32"
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
    cidr_blocks = [local.access_ip]
  }

  ingress {
    description = "HTTPS"
    from_port   = 5443
    to_port     = 5443
    protocol    = "tcp"
    cidr_blocks = [local.access_ip]
  }

  ingress {
    description = "RTMP"
    from_port   = 1935
    to_port     = 1935
    protocol    = "tcp"
    cidr_blocks = [local.access_ip]
  }

  ingress {
    description = "RTSP"
    from_port   = 5554
    to_port     = 5554
    protocol    = "tcp"
    cidr_blocks = [local.access_ip]
  }

  ingress {
    description = "SRT"
    from_port   = 4200
    to_port     = 4200
    protocol    = "tcp"
    cidr_blocks = [local.access_ip]
  }

  ingress {
    description = "WebRTC and RTSP"
    from_port   = 5000
    to_port     = 65000
    protocol    = "udp"
    cidr_blocks = [local.access_ip]
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
