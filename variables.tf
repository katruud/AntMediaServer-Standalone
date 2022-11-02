variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "az" {
  description = "AWS AZ"
  # ARM support in us-east-1a, us-east-1b, us-east-1c, us-east-1d, us-east-1f
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "c6g.large"
}

variable "instance_name" {
  description = "EC2 instance name"
  default     = "Ant Media Server Standalone"
}

variable "instance_private_ip" {
  description = "EC2 private IP"
  default     = "10.0.0.4"
}

variable "vpc_cidr" {
  description = "CIDR range of VPC"
  default     = "10.0.0.0/24"
}

variable "subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

# Find our public IP https://stackoverflow.com/questions/46763287
data "http" "myip" {
  url = "http://ipv4.icanhazip.com/ip"
}
