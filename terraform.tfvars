region = "us-east-1"
az = "us-east-1a"
# ARM support in us-east-1a, us-east-1b, us-east-1c, us-east-1d, us-east-1f
instance_type = "c6g.large"
instance_name = "Ant Media Server Standalone"
instance_private_ip = "10.0.0.4"
vpc_cidr = "10.0.0.0/24"
subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
# Specific IPs to grant access
access_ips = []