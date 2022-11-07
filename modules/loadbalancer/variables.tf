variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "certificate" {
  description = "ARN of certificate"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "private_subnet_id" {
  description = "Private subnet ID"
}

variable "public_subnet_id" {
  description = "Public subnet ID"
}

variable "instance_id" {
  description = "EC2 instance ID"
}

variable "creator" {
  description = "Creator of resource"
}

variable "appname" {
  description = "Name of app"
  default     = "Ant Media Server"
}