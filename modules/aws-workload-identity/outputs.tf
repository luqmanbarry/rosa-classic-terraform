output "oidc_provider_arn" {
  value = var.enabled ? local.oidc_provider_arn : null
}

output "role_arns" {
  value = {
    for name, role in aws_iam_role.workload_identity : name => role.arn
  }
}

output "service_account_annotations" {
  value = {
    for name, role in aws_iam_role.workload_identity : name => {
      namespace       = var.roles[name].namespace
      service_account = var.roles[name].service_account
      annotations = {
        "eks.amazonaws.com/role-arn" = role.arn
      }
    }
  }
}
