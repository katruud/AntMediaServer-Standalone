# ARM support in us-east-1a, us-east-1b, us-east-1c, us-east-1d, us-east-1f
variable "az" {
  type        = list(string)
  description = "AWS AZ"
}

variable "region" {
  description = "AWS Region"
}

variable "instance_type" {
  description = "Type of EC2 instance to provision"
}

variable "architecture" {
  description = "Type of EC2 architecture"
}

variable "instance_private_ip" {
  type        = list(string)
  description = "EC2 private IP"
}

variable "vpc_cidr" {
  description = "CIDR range of VPC"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "public_udp_cidrs" {
  type        = list(string)
  description = "CIDR Range for WebRTC UDP access"
  default     = ["0.0.0.0/0"]
}

variable "instances" {
  description = "Number of EC2 instances to provision"
}

variable "certificate" {
  description = "HTTPS Certificate for ALB"
}

variable "appname" {
  description = "Application name"
  default     = "Ant Media Server"
}

variable "creator" {
  description = "Creator of resource"
}