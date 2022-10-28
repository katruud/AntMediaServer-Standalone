variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "c5.large"
}

variable "instance_name" {
  description = "EC2 instance name"
  default     = "Ant Media Server Standalone"
}

variable "vpc_cidr" {
  description = "CIDR range of VPC"
  default     = "10.0.0.0/24"
}

variable "access_ip" {
  description = "IP Address with access to server (x.x.x.x/32)"
  type        = string
}