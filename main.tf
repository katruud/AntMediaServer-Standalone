provider "aws" {
  region = var.region
}

# AMS AMI Search
data "aws_ami" "ant_media" {
  most_recent = true

  filter {
    name   = "name"
    values = ["AntMedia-AWS-Marketplace-EE-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

# AMS EC2 Instance
resource "aws_instance" "ant_media" {
  ami                    = data.aws_ami.ant_media.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ams_sg.id]

  tags = {
    Name = var.instance_name
  }
}

# Security Group
resource "aws_security_group" "ams_sg" {
  name        = "Ant Media Server Standalone"
  description = "AMS SG with single-IP access"

  ingress {
    description = "HTTP"
    from_port   = 5080
    to_port     = 5080
    protocol    = "tcp"
    cidr_blocks = [var.access_ip]
  }

  ingress {
    description = "HTTPS"
    from_port   = 5443
    to_port     = 5443
    protocol    = "tcp"
    cidr_blocks = [var.access_ip]
  }

  ingress {
    description = "RTMP"
    from_port   = 1935
    to_port     = 1935
    protocol    = "tcp"
    cidr_blocks = [var.access_ip]
  }

  ingress {
    description = "RTSP"
    from_port   = 5554
    to_port     = 5554
    protocol    = "tcp"
    cidr_blocks = [var.access_ip]
  }

  ingress {
    description = "SRT"
    from_port   = 4200
    to_port     = 4200
    protocol    = "tcp"
    cidr_blocks = [var.access_ip]
  }

  ingress {
    description = "WebRTC and RTSP"
    from_port   = 5000
    to_port     = 65000
    protocol    = "udp"
    cidr_blocks = [var.access_ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ams-sg"
  }
}
