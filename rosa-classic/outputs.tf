output "oidc_thumbprint" {
  value = rhcs_rosa_oidc_config.oidc_config.oidc_endpoint_url
}

output "oidc_endpoint_url" {
  value = rhcs_rosa_oidc_config.oidc_config.oidc_endpoint_url
}

output "cluster_id" {
  value = data.rhcs_cluster_rosa_classic.get_cluster.id
}

output "cluster_name" {
  value = data.rhcs_cluster_rosa_classic.get_cluster.name
}

output "api_url" {
  value = data.rhcs_cluster_rosa_classic.get_cluster.api_url
}

output "console_url" {
  value = data.rhcs_cluster_rosa_classic.get_cluster.console_url
}

output "domain" {
  value = rhcs_cluster_rosa_classic.rosa_sts_cluster.domain
}

output "admin_username" {
  value = local.username
  sensitive = true
}

output "admin_password" {
  value = local.password
  sensitive = true
}