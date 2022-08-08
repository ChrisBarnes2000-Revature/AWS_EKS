terraform {
  # terriform version
  required_version = "~> 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.25.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }

    # helm = {
    #   source  = "hashicorp/helm"
    #   version = "2.6.0"
    # }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }

  # add state to bucket
  # backend "s3" {
  #   bucket = "mybucket"
  #   key    = "path/to/my/key"
  #   region = "us-east-1"
  # }

}

# --------------------------- #
# -------- Providers -------- #
# --------------------------- #

provider "aws" {
  # COE supplies credentials
  region = var.region
  shared_credentials_files = {
    value = "~/.aws/credentials"
  }

  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  profile = var.profile
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}

# removed helm. install helm after terraform sets up cluster
# provider "helm" {
#   kubernetes {
#     host                   = module.eks.cluster_endpoint
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
#       command     = "aws"
#     }
#   }
# }

# --------------------------- #
# -------- RESOURCES -------- #
# --------------------------- #

resource "random_string" "suffix" {
  length  = 6
  special = false
}

# --------------------------- #
# --------DATA SOURCE-------- #
# --------------------------- #

data "aws_availability_zones" "available" {}

data "aws_eks_cluster" "default" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_id
}

# ------------------------- #
# --------LOCAL VAR-------- #
# ------------------------- #

locals {
  # cluster_name = "${var.user_name}-cluster-${random_string.suffix.result}" # random ensures no cluster repeats.
  cluster_name = "${var.user_name}-cluster"
}
