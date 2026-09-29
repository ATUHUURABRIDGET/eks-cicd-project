############################################
# TERRAFORM PROVIDER
############################################
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

############################################
# VPC MODULE
############################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

############################################
# EKS MODULE (v21.x)
############################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  # Cluster identity
  name               = var.cluster_name
  kubernetes_version = "1.31"

  # Authentication mode
  authentication_mode = "API_AND_CONFIG_MAP"

  # Makes YOUR IAM user the cluster admin
  enable_cluster_creator_admin_permissions = true

  # VPC wiring
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Endpoint settings
  endpoint_public_access  = true
  endpoint_private_access = false

  ############################################
  # ADD-ONS (critical: install CNI before nodes)
  ############################################
  addons = {
    vpc-cni = {
      before_compute = true
    }
    kube-proxy = {}
    coredns    = {}
  }

  ############################################
  # NODE GROUP (with autoscaler tags)
  ############################################
  eks_managed_node_groups = {
    default = {
      instance_types = [var.instance_type]

      min_size     = 1
      desired_size = var.desired_capacity
      max_size     = var.max_capacity

      capacity_type = "ON_DEMAND"

      tags = {
        "k8s.io/cluster-autoscaler/enabled" = "true"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
      }
    }
  }

  tags = {
    Environment = "TechChallenge"
    Project     = var.cluster_name
  }
}
