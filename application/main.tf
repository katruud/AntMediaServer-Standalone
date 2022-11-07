provider "aws" {
  region = var.region
}

module "vpc" {
  source = "../modules/vpc"

  az                   = var.az
  vpc_cidr             = var.vpc_cidr
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  appname              = var.appname
  creator              = var.creator
}

module "instances" {
  source = "../modules/instances"

  public_udp_cidrs    = var.public_udp_cidrs
  public_subnet_cidrs = var.public_subnet_cidrs
  instance_type       = var.instance_type
  architecture        = var.architecture
  instance_private_ip = var.instance_private_ip
  instances           = var.instances
  az                  = var.az
  appname             = var.appname
  creator             = var.creator

  vpc_id            = module.vpc.vpc_id
  private_subnet_id = module.vpc.private_subnet_id
}

module "loadbalancer" {
  source = "../modules/loadbalancer"

  private_subnet_cidrs = var.private_subnet_cidrs
  certificate          = var.certificate
  appname              = var.appname
  creator              = var.creator

  vpc_id            = module.vpc.vpc_id
  private_subnet_id = module.vpc.private_subnet_id
  public_subnet_id  = module.vpc.public_subnet_id
  instance_id       = module.instances.instance_id
}