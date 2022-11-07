# ARM support in us-east-1a, us-east-1b, us-east-1c, us-east-1d, us-east-1f
variable "az" {
  type        = list(string)
  description = "AWS AZ"
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

variable "creator" {
  description = "Creator of resource"
}

variable "appname" {
  description = "Name of app"
  default     = "Ant Media Server"
}