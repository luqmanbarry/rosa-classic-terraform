module "rosa-classic_account-iam-resources" {
  
  count = var.create_account_roles ? 1 : 0

  source  = "terraform-redhat/rosa-classic/rhcs//modules/account-iam-resources"

  account_role_prefix    = local.account_role_prefix
  openshift_version      = regex("^[0-9]+\\.[0-9]+", var.ocp_version)
  path                   = local.path
  
  tags = merge(
    {
      cluster_name = var.cluster_name
    },
    var.additional_tags
  )
}

resource "time_sleep" "wait_10_seconds" {
  depends_on = [ module.rosa-classic_account-iam-resources ]

  create_duration = "10s"
}