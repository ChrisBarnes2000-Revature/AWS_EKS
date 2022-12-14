output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

# show control plane endpoint
output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

# control plane security group id
output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name
}

# output "cluster_ca_certificate" {
#   value = aws_eks_cluster.this.certificate_authority[0].data
# }

# output "aws-keys" {
#   value = {
#     access_key = aws_iam_access_key.eks-access-key.id
#     secret_key = aws_iam_access_key.eks-access-key.secret
#   }
#   sensitive = true
# }