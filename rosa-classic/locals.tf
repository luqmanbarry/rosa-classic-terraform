locals {
  ldap_root_ca_keyname = "ca_crt"

  account_role_prefix = var.cluster_name
  operator_role_prefix = var.cluster_name

  path = coalesce(var.path, "/")
  custom_dns_domain = format("apps.%s.%s.%s.%s", var.business_unit, var.cluster_name, var.openshift_environment, var.base_dns_domain)
  sts_roles = {
    role_arn         = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role${local.path}${local.account_role_prefix}-Installer-Role",
    support_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role${local.path}${local.account_role_prefix}-Support-Role",
    instance_iam_roles = {
      master_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role${local.path}${local.account_role_prefix}-ControlPlane-Role",
      worker_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role${local.path}${local.account_role_prefix}-Worker-Role"
    },
    operator_role_prefix = local.operator_role_prefix,
    oidc_config_id       = module.rosa-classic_oidc-config-and-provider.oidc_config_id
  }
  
  worker_node_replicas  = var.autoscaling_enabled ?  null : var.worker_node_replicas
  cluster_name = coalesce(var.cluster_name, "rosa-${random_string.random_name.result}")

  rosa_details_secret_name  = format("%s/%s/%s", var.business_unit, var.admin_creds_vault_secret_name_prefix, var.cluster_name)
  username = var.admin_creds_vault_generate ? random_uuid.username[0].result : var.admin_creds_username
  password = var.admin_creds_vault_generate ? random_password.password[0].result : var.admin_creds_password

  custom_base_domain                = format("apps.%s.%s.%s.%s", var.business_unit, var.cluster_name, var.openshift_environment, var.base_dns_domain)
  custom_ingress_domain             = format("%s.%s", var.custom_ingress_domain_prefix, local.custom_base_domain)  
}