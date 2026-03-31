output "cluster_name" {
  value = var.cluster_name
}

output "root_application_name" {
  value = format("%s-root", var.cluster_name)
}
