## CREATE OIDC CONFIG
resource "rhcs_rosa_oidc_config" "oidc_config" {
  managed = var.managed_oidc
}

data "rhcs_rosa_operator_roles" "operator_roles" {
  operator_role_prefix = local.operator_role_prefix
  account_role_prefix  = var.account_role_prefix
}

module "oidc_provider" {
  source  = "terraform-redhat/rosa-sts/aws"
  version = "0.0.15"

  create_operator_roles = false
  create_oidc_provider  = true

  cluster_id = ""
  
  rh_oidc_provider_thumbprint = rhcs_rosa_oidc_config.oidc_config.thumbprint
  rh_oidc_provider_url        = rhcs_rosa_oidc_config.oidc_config.oidc_endpoint_url
  tags                        = var.additional_tags
  path                        = var.path
}

resource "time_sleep" "wait_for_oidc" {
  depends_on      = [ module.oidc_provider ]
  create_duration = "15s"
}