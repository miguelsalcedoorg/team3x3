variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}


provider "aws" {
  shared_config_files      = ["C:/Users/19526/.aws/config"]
  shared_credentials_files = ["C:/Users/19526/.aws/credentials"]
  profile                  = "ThompTyler"
  region  = "us-east-1"
}


data "aws_availability_zones" "available" {}


locals {
  cluster_name = "team3-eks-cluster-${random_string.suffix.result}"
}


resource "random_string" "suffix" {
  length  = 8
  special = false
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"


  name                 = "team3-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true


  tags = {
    "team3/cluster/${local.cluster_name}" = "shared"
  }


  public_subnet_tags = {
    "team3/cluster/${local.cluster_name}" = "shared"
    "team3/role/elb"                      = "1"
  }


  private_subnet_tags = {
    "team3/cluster/${local.cluster_name}" = "shared"
    "team3/role/internal-elb"             = "1"
  }
}
