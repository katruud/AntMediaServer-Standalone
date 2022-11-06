variable "region" {
  description = "AWS region"
}

# ARM support in us-east-1a, us-east-1b, us-east-1c, us-east-1d, us-east-1f
variable "az" {
  type        = list(string)
  description = "AWS AZ"
}

variable "instance_type" {
  description = "Type of EC2 instance to provision"
}

variable "instance_name" {
  description = "EC2 instance name"
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

variable "access_ips" {
  type        = list(string)
  description = "Additional IPs to grant access"
}

variable "instances" {
  description = "Number of EC2 instances to provision"
}

variable "certificate" {
  description = "ARN of certificate"
}

variable "zone_name" {
  description = "Name of hosted zone"
}

variable "creator" {
  description = "Creator of resource"
}