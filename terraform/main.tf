provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "my-vpc-01" {
  cidr_block = "10.0.0.0/16" 
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnets" {
  count             = 3 
  vpc_id            = aws_vpc.my-vpc-01.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = "ap-southeast-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnets" {
  count             = 3
  vpc_id            = aws_vpc.my-vpc-01.id
  cidr_block        = "10.0.${count.index + 2}.0/24"
  availability_zone = "ap-southeast-1b"
}

resource "aws_security_group" "eks_cluster" {
  name_prefix = "eks-cluster-"
  description = "EKS cluster security group"
  vpc_id      = aws_vpc.my-vpc-01.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "eks-cluster-security-group"
  }
}

resource "aws_security_group" "eks_nodes" {
  name_prefix = "eks-nodes-"
  description = "EKS worker node security group"
  vpc_id      = aws_vpc.my-vpc-01.id
  tags = {
    Name = "eks-nodes-security-group"
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "EKS-cluster"
  cluster_version = "1.21"
  vpc_id          = aws_vpc.my-vpc-01.id

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t3.large"]
    }
  }
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}
