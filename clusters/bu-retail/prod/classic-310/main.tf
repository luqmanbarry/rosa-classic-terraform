module "factory_stack" {
  source = "../../../../modules/factory-stack"

  stack = var.stack

  ocm_token                           = var.ocm_token
  vault_token                         = var.vault_token
  vault_login_approle_role_id         = var.vault_login_approle_role_id
  vault_login_approle_secret_id       = var.vault_login_approle_secret_id
  vault_addr                          = var.vault_addr
  acmhub_kubeconfig_filename          = var.acmhub_kubeconfig_filename
  managed_cluster_kubeconfig_filename = var.managed_cluster_kubeconfig_filename
  gitops_repo_username                = var.gitops_repo_username
  gitops_repo_password                = var.gitops_repo_password
}
