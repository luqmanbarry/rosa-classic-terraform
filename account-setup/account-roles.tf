data "rhcs_versions" "all" {
  count = var.create_account_roles ? 1 : 0
}

data "rhcs_policies" "all_policies" {}

module "rosa-classic_account-iam-resources" {
  
  count = var.create_account_roles ? 1 : 0

  ## OLD CONFIGS
  source  = "terraform-redhat/rosa-sts/aws"
  version = "0.0.15"

  create_account_roles  = var.create_account_roles
  create_operator_roles = false

  account_role_prefix    = var.account_role_prefix
  path                   = local.path
  rosa_openshift_version = regex("^[0-9]+\\.[0-9]+", var.ocp_version)
  account_role_policies  = data.rhcs_policies.all_policies.account_role_policies
  all_versions           = data.rhcs_versions.all[0]
  operator_role_policies = data.rhcs_policies.all_policies.operator_role_policies
  tags                   = var.additional_tags

  ## NEW CONFIGS
  # source  = "terraform-redhat/rosa-classic/rhcs/modules/account-iam-resources"
  # account_role_prefix    = var.account_role_prefix
  # openshift_version      = regex("^[0-9]+\\.[0-9]+", var.ocp_version)
  # path                   = local.path
  # tags                   = var.additional_tags
}

resource "time_sleep" "wait_10_seconds" {
  depends_on = [ module.rosa-classic_account-iam-resources ]

  create_duration = "10s"
}