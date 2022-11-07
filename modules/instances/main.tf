# AMS AMI Search
data "aws_ami" "ant_media_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["AntMedia-AWS-Marketplace-EE-*"]
  }

  filter {
    name   = "architecture"
    values = var.architecture
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
    Name      = "Ant Media Server Enterprise"
    CreatedBy = var.creator
    AppName   = var.appname
    Name      = "Ant Media Instance ${count.index + 1}"
  }
}

resource "aws_network_interface" "ant_media_interface" {
  count           = var.instances
  subnet_id       = element(var.private_subnet_id[*], count.index)
  private_ips     = [element(var.instance_private_ip[*], count.index)]
  security_groups = [aws_security_group.ant_media_ec2_sg.id]

  tags = {
    CreatedBy = var.creator
    AppName   = "ant-media-server"
    Name      = format("%s %s", "Network interface", "${count.index + 1}")
  }
}

# EC2 security group
resource "aws_security_group" "ant_media_ec2_sg" {
  name        = "Ant Media Server Standalone"
  description = "AMS SG with single-IP access"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 5080
    to_port     = 5080
    protocol    = "TCP"
    # Need to allow TCP health check from NLB
    # security_groups = [aws_security_group.ant_media_alb_sg.id]
    cidr_blocks = var.public_subnet_cidrs
  }

  ingress {
    description = "HTTPS"
    from_port   = 5443
    to_port     = 5443
    protocol    = "TCP"
    cidr_blocks = var.public_subnet_cidrs
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
  ingress {
    description = "WebRTC and RTSP"
    from_port   = 5000
    to_port     = 65000
    protocol    = "udp"
    cidr_blocks = var.public_udp_cidrs
  }

  tags = {
    CreatedBy = var.creator
    AppName   = var.appname
    Name      = "AMS EC2 SG"
  }
}