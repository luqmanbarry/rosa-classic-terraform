module "rosa-classic_oidc-config-and-provider" {
  source  = "terraform-redhat/rosa-classic/rhcs//modules/oidc-config-and-provider"
  # version = "1.5.0"

  installer_role_arn          = var.managed_oidc ? null : data.aws_caller_identity.current.arn
  managed                     = var.managed_oidc
  tags = merge(
    {
      cluster_name = var.cluster_name
    },
    var.additional_tags
  )
}

resource "time_sleep" "wait_for_oidc" {
  depends_on      = [ module.rosa-classic_oidc-config-and-provider ]
  create_duration = "15s"
}