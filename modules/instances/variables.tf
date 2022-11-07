# ARM support in us-east-1a, us-east-1b, us-east-1c, us-east-1d, us-east-1f
variable "az" {
  type        = list(string)
  description = "AWS AZ"
}

variable "public_udp_cidrs" {
  description = "Access range for UDP WebRTC ports"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "private_subnet_id" {
  description = "Private subnet ID"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRS"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "instance_type" {
  description = "Type of EC2 instance to provision"
}

variable "architecture" {
  description = "Architecture of EC2 instance"
  default     = ["x86_64"]
}

variable "instance_private_ip" {
  type        = list(string)
  description = "EC2 private IP"
}

variable "instances" {
  description = "Number of EC2 instances to provision"
}

variable "creator" {
  description = "Creator of resource"
}

variable "appname" {
  description = "Name of app"
  default     = "Ant Media Server"
}