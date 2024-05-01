module "rosa-classic_operator-policies" {
  source  = "terraform-redhat/rosa-classic/rhcs//modules/operator-policies"
  
  account_role_prefix     = local.account_role_prefix
  openshift_version       = var.ocp_version
  path                    = local.path

  tags = merge(
    {
      cluster_name = var.cluster_name
    },
    var.additional_tags
  )
}

module "rosa-classic_operator-roles" {
  depends_on  = [ 
    module.rosa-classic_operator-policies,
    rhcs_cluster_rosa_classic.rosa_sts_cluster 
  ]
  source  = "terraform-redhat/rosa-classic/rhcs//modules/operator-roles"
  # version = "1.5.0"

  account_role_prefix         = local.account_role_prefix
  oidc_endpoint_url           = module.rosa-classic_oidc-config-and-provider.oidc_endpoint_url
  operator_role_prefix        = local.operator_role_prefix
  path                        = local.path

  tags = merge(
    {
      cluster_name = var.cluster_name
    },
    var.additional_tags
  )
}

resource "time_sleep" "wait_for_operator_roles" {
  depends_on = [module.rosa-classic_operator-roles]

  create_duration = "15s"
}