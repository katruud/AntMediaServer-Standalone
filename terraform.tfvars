region = "us-east-1"
# Specify AZ for subnets
az = ["us-east-1a", "us-east-1b"]
# ARM support in us-east-1a, us-east-1b, us-east-1c, us-east-1d, us-east-1f
instance_type = "c6g.large"
instance_name = "Ant Media Server Standalone"
instance_private_ip = ["10.0.1.4", "10.0.1.4"]
vpc_cidr = "10.0.0.0/16"
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
# Specific IPs to grant access
access_ips = []
# Number of EC2 to provision, <= number of ips/subnets
instances = 1