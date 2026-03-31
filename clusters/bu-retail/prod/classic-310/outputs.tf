output "cluster_id" {
  value = module.factory_stack.cluster_id
}

output "api_url" {
  value = module.factory_stack.api_url
}

output "console_url" {
  value = module.factory_stack.console_url
}

output "gitops_root_application_name" {
  value = module.factory_stack.gitops_root_application_name
}

output "aws_workload_identity_role_arns" {
  value = module.factory_stack.aws_workload_identity_role_arns
}

output "aws_workload_identity_service_account_annotations" {
  value = module.factory_stack.aws_workload_identity_service_account_annotations
}
