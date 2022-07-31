# Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.26.6"

  cluster_name    = local.cluster_name
  cluster_version = "1.22"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
    # ami_id = "ami-052efd3df9dad4825"  # ubuntu server LTS 20.04

    attach_cluster_primary_security_group = true

    # Disabling and using externally provided security groups
    create_security_group = false
  }

  eks_managed_node_groups = {
    # aws_launch_template
    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template
    one = {
      name = "worker-node-group-1"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 2
      desired_size = 1

      # pre_bootstrap_user_data = <<-EOT
      # echo 'foo bar'
      # EOT

      vpc_security_group_ids = [
        aws_security_group.node_group_one.id
      ]

      key_name = aws_key_pair.eks_nodes.key_name
    }

    # two = {
    #   name = "worker-node-group-2"

    #   instance_types = ["t3.medium"]

    #   min_size     = 1
    #   max_size     = 2
    #   desired_size = 1

    #   pre_bootstrap_user_data = <<-EOT
    #   echo 'foo bar'
    #   EOT

    #   vpc_security_group_ids = [
    #     aws_security_group.node_group_two.id
    #   ]

    #   key_name = aws_key_pair.eks_nodes.key_name
    # }
  }
}

resource "aws_key_pair" "eks_nodes" {
  key_name   = "eks-node-key"
  public_key = file("./.ssh/id_rsa.pub")
}
