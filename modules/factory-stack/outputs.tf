output "cluster_id" {
  value = module.core.cluster_id
}

output "cluster_name" {
  value = module.core.cluster_name
}

output "api_url" {
  value = module.core.api_url
}

output "console_url" {
  value = module.core.console_url
}

output "domain" {
  value = module.core.domain
}

output "gitops_root_application_name" {
  value = module.gitops_bootstrap.root_application_name
}

output "acm_registration_enabled" {
  value = local.acm_enabled
}

output "vpc_id" {
  value = local.create_aws_resources ? module.infra[0].vpc_id : local.stack.network.vpc_id
}

output "aws_workload_identity_enabled" {
  value = local.aws_workload_identity_enabled
}

output "aws_workload_identity_role_arns" {
  value = module.aws_workload_identity.role_arns
}

output "aws_workload_identity_service_account_annotations" {
  value = module.aws_workload_identity.service_account_annotations
}
