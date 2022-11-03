variable "region" {
  description = "AWS region"
}

variable "az" {
  description = "AWS AZ"
}

variable "instance_type" {
  description = "Type of EC2 instance to provision"
}

variable "instance_name" {
  description = "EC2 instance name"
}

variable "instance_private_ip" {
  description = "EC2 private IP"
}

variable "vpc_cidr" {
  description = "CIDR range of VPC"
}

variable "subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
}

variable "access_ips" {
 type        = list(string)
 description = "Private Subnet CIDR values"
}
