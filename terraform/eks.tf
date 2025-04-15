# https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.35.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.32"

  vpc_id                   = module.vpc.vpc_id
  control_plane_subnet_ids = module.vpc.private_subnets
  subnet_ids               = module.vpc.private_subnets

  # add-on setting
  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {}
  }

  # cluster setting
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
  cluster_service_ipv4_cidr       = "192.168.0.0/16"
  cluster_security_group_name     = "${var.cluster_name}-sg"
  authentication_mode             = "API"

  # Cluster access Entry
  access_entries = {

    # Cluster admin role
    cluster_admin = {
      principal_arn = var.cluster_admin_role
      policy_associations = {
        admin_policy = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }

    # Developer role
    developer = {
      principal_arn = var.cluster_developer_role
      policy_associations = {
        dev_policy = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"
          access_scope = {
            type       = "namespace"
            namespaces = ["default"]
          }
        }
      }
    }
  }

  # Nodegroup setting
  eks_managed_node_groups = {
    spring-boot = {
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2

      labels = {
        application = "springboot"
      }
    }

    fast-api = {
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2

      labels = {
        application = "fastapi"
      }
    }
  }

}
