module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.16"

  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_id

  create_cluster_security_group = false
  create_node_security_group    = false

  eks_managed_node_groups = {
    default = {
      name                 = "devops-tools"
      instance_types       = ["t3.medium"]
      force_update_version = true
      release_version      = var.ami_release_version

      min_size     = 2
      max_size     = 4
      desired_size = 2

      update_config = {
        max_unavailable_percentage = 50
      }

      labels = {
        workshop-default = "yes"
      }
    }
  }

  tags = merge(local.tags, {
    "karpenter.sh/discovery" = var.cluster_name
  })
}


resource "null_resource" "update_kubeconfig" {
  triggers = {
    eks_cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data[0].data
    eks_cluster_endpoint                   = module.eks.cluster_endpoint
  }

  provisioner "local-exec" {
    command = <<EOT
aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}
EOT
  }
}