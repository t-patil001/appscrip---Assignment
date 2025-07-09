output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_kubeconfig" {
  value = module.eks.kubeconfig
}

output "region" {
  value = var.region
}
