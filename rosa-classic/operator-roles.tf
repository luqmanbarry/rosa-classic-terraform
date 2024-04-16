data "rhcs_policies" "all_policies" {}

data "rhcs_versions" "all" {}

module "operator_roles" {
  depends_on  = [ rhcs_cluster_rosa_classic.rosa_sts_cluster ]

  # source  = "terraform-redhat/rosa-sts/aws"
  # version = "0.0.15"
  source  = "terraform-redhat/terraform-rhcs-rosa-classic"
  version = "v1.5.0"

  create_operator_roles = true
  create_oidc_provider  = false

  rh_oidc_provider_thumbprint = rhcs_rosa_oidc_config.oidc_config.thumbprint
  rh_oidc_provider_url        = rhcs_rosa_oidc_config.oidc_config.oidc_endpoint_url
  rosa_openshift_version      = regex("^[0-9]+\\.[0-9]+", var.ocp_version)
  cluster_id                  = ""
  operator_role_policies      = data.rhcs_policies.all_policies.operator_role_policies 
  operator_roles_properties   = data.rhcs_rosa_operator_roles.operator_roles.operator_iam_roles
  tags                        = var.additional_tags
  path                        = local.path
}

resource "time_sleep" "wait_for_operator_roles" {
  depends_on = [module.operator_roles]

  create_duration = "15s"
}