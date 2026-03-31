locals {
  stack = var.stack

  business_unit                 = try(local.stack.business_metadata.business_unit, "platform")
  openshift_environment         = try(local.stack.environment, try(local.stack.openshift_environment, "dev"))
  create_aws_resources          = try(local.stack.infrastructure.create_aws_resources, false)
  acm_enabled                   = try(local.stack.acm.enabled, false)
  aws_workload_identity_enabled = try(local.stack.identity.aws_workload_identity.enabled, false)

  additional_tags = merge(
    {
      Terraform   = "true"
      environment = local.openshift_environment
    },
    try(local.stack.cluster.additional_tags, {}),
    try(local.stack.additional_tags, {})
  )

  network_vpc_id             = local.create_aws_resources ? module.infra[0].vpc_id : local.stack.network.vpc_id
  network_vpc_cidr_block     = local.create_aws_resources ? module.infra[0].vpc_cidr_block : local.stack.network.vpc_cidr_block
  network_private_subnet_ids = local.create_aws_resources ? module.infra[0].private_subnet_ids : try(local.stack.network.private_subnet_ids, [])
  network_public_subnet_ids  = local.create_aws_resources ? module.infra[0].public_subnet_ids : try(local.stack.network.public_subnet_ids, [])
  network_availability_zones = local.create_aws_resources ? module.infra[0].availability_zones : try(local.stack.network.availability_zones, [])
  network_hosted_zone_id     = local.create_aws_resources ? module.infra[0].hosted_zone_id : local.stack.network.hosted_zone_id
  additional_compute_sg_ids  = local.create_aws_resources ? concat(try(local.stack.cluster.aws_additional_compute_security_group_ids, []), [module.infra[0].additional_security_group]) : try(local.stack.cluster.aws_additional_compute_security_group_ids, [])
}

module "infra" {
  count  = local.create_aws_resources ? 1 : 0
  source = "../rosa-classic-infra"

  ocm_token                 = var.ocm_token
  ocm_url                   = try(local.stack.ocm_url, "https://api.openshift.com")
  account_role_prefix       = try(local.stack.cluster.account_role_prefix, "ManagedOpenShift")
  openshift_environment     = local.openshift_environment
  aws_region                = local.stack.aws_region
  business_unit             = local.business_unit
  create_account_roles      = try(local.stack.cluster.create_account_roles, false)
  ocp_version               = try(local.stack.openshift_version, local.stack.cluster.ocp_version)
  cluster_name              = local.stack.cluster_name
  vpc_cidr_block            = local.stack.network.vpc_cidr_block
  availability_zones        = try(local.stack.network.availability_zones, [])
  private_subnet_cidrs      = try(local.stack.network.private_subnet_cidrs, [])
  public_subnet_cidrs       = try(local.stack.network.public_subnet_cidrs, [])
  single_nat_gateway        = try(local.stack.infrastructure.single_nat_gateway, true)
  additional_tags           = local.additional_tags
  base_dns_domain           = local.stack.network.base_dns_domain
  ocp_sg_inbound_from_port  = try(local.stack.infrastructure.ocp_sg_inbound_from_port, 30000)
  ocp_sg_inbound_to_port    = try(local.stack.infrastructure.ocp_sg_inbound_to_port, 32900)
  cicd_instance_cidr        = try(local.stack.infrastructure.cicd_instance_cidr, "10.254.0.0/16")
  cicd_sg_inbound_from_port = try(local.stack.infrastructure.cicd_sg_inbound_from_port, 30000)
  cicd_sg_inbound_to_port   = try(local.stack.infrastructure.cicd_sg_inbound_to_port, 32900)
}

module "core" {
  source = "../rosa-classic-core"

  business_unit = local.business_unit
  ocm_token     = var.ocm_token

  ocm_url              = try(local.stack.ocm_url, "https://api.openshift.com")
  create_account_roles = try(local.stack.cluster.create_account_roles, false)
  ocp_version          = try(local.stack.openshift_version, local.stack.cluster.ocp_version)
  cluster_name         = local.stack.cluster_name
  additional_tags      = local.additional_tags
  path                 = try(local.stack.cluster.path, null)
  machine_type         = try(local.stack.cluster.machine_type, "m5.xlarge")
  worker_node_replicas = try(local.stack.cluster.worker_node_replicas, 3)
  autoscaling_enabled  = try(local.stack.cluster.autoscaling_enabled, false)
  min_replicas         = try(local.stack.cluster.min_replicas, 3)
  max_replicas         = try(local.stack.cluster.max_replicas, 3)
  proxy = try(local.stack.cluster.proxy, {
    enable      = false
    http_proxy  = ""
    https_proxy = ""
  })
  private_cluster                                 = try(local.stack.cluster.private, false)
  pod_cidr                                        = try(local.stack.cluster.pod_cidr, "10.128.0.0/14")
  service_cidr                                    = try(local.stack.cluster.service_cidr, "172.30.0.0/16")
  ldap_vault_secret_name                          = try(local.stack.cluster.ldap_vault_secret_name, "identity-providers/dev/ldap")
  aad_vault_secret_name                           = try(local.stack.cluster.aad_vault_secret_name, "identity-providers/dev/aad")
  github_idp_vault_secret_name                    = try(local.stack.cluster.github_idp_vault_secret_name, "identity-providers/dev/github")
  gitlab_idp_vault_secret_name                    = try(local.stack.cluster.gitlab_idp_vault_secret_name, "identity-providers/dev/gitlab")
  vpc_id                                          = local.network_vpc_id
  vpc_cidr_block                                  = local.network_vpc_cidr_block
  aws_region                                      = local.stack.aws_region
  private_subnet_ids                              = local.network_private_subnet_ids
  public_subnet_ids                               = local.network_public_subnet_ids
  admin_creds_username                            = try(local.stack.cluster.admin_creds_username, "cluster-admin")
  admin_creds_password                            = try(local.stack.cluster.admin_creds_password, "changeme")
  admin_creds_vault_generate                      = try(local.stack.cluster.admin_creds_vault_generate, true)
  admin_creds_save_to_vault                       = try(local.stack.cluster.admin_creds_save_to_vault, false)
  ocp_vault_secret_engine_mount                   = try(local.stack.cluster.ocp_vault_secret_engine_mount, "kv")
  admin_creds_vault_secret_name_prefix            = try(local.stack.cluster.admin_creds_vault_secret_name_prefix, "rosa/cluster-admins/dev")
  hosted_zone_id                                  = local.network_hosted_zone_id
  vault_token                                     = var.vault_token
  vault_login_approle_role_id                     = var.vault_login_approle_role_id
  vault_login_approle_secret_id                   = var.vault_login_approle_secret_id
  vault_addr                                      = var.vault_addr
  availability_zones                              = local.network_availability_zones
  ocm_environment                                 = try(local.stack.ocm_environment, "production")
  openshift_environment                           = local.openshift_environment
  account_role_prefix                             = try(local.stack.cluster.account_role_prefix, "ManagedOpenShift")
  base_dns_domain                                 = local.stack.network.base_dns_domain
  managed_oidc                                    = try(local.stack.cluster.managed_oidc, true)
  use_static_oidc_configs                         = try(local.stack.cluster.use_static_oidc_configs, true)
  aws_additional_compute_security_group_ids       = local.additional_compute_sg_ids
  aws_additional_control_plane_security_group_ids = try(local.stack.cluster.aws_additional_control_plane_security_group_ids, [])
  aws_additional_infra_security_group_ids         = try(local.stack.cluster.aws_additional_infra_security_group_ids, [])
  default_mp_labels                               = try(local.stack.cluster.default_mp_labels, {})
}

module "aws_workload_identity" {
  source = "../aws-workload-identity"

  enabled           = local.aws_workload_identity_enabled
  cluster_name      = local.stack.cluster_name
  oidc_endpoint_url = module.core.oidc_endpoint_url
  oidc_audience     = try(local.stack.identity.aws_workload_identity.oidc_audience, "sts.amazonaws.com")
  additional_tags   = local.additional_tags
  roles             = try(local.stack.identity.aws_workload_identity.roles, {})
}

module "acm_registration" {
  count  = local.acm_enabled ? 1 : 0
  source = "../rosa-classic-acm-registration"
  providers = {
    kubernetes.managed_cluster = kubernetes.managed_cluster
    kubernetes.acmhub_cluster  = kubernetes.acmhub_cluster
  }

  business_unit                       = local.business_unit
  cluster_name                        = local.stack.cluster_name
  managed_cluster_kubeconfig_filename = var.managed_cluster_kubeconfig_filename
  acmhub_kubeconfig_filename          = var.acmhub_kubeconfig_filename
  openshift_environment               = local.openshift_environment
}

module "gitops_bootstrap" {
  source = "../openshift-gitops-bootstrap"

  enabled                             = try(local.stack.gitops.bootstrap_enabled, false)
  managed_cluster_kubeconfig_filename = var.managed_cluster_kubeconfig_filename
  cluster_name                        = local.stack.cluster_name
  gitops_operator_namespace           = try(local.stack.gitops.operator_namespace, "openshift-gitops-operator")
  gitops_namespace                    = try(local.stack.gitops.namespace, "openshift-gitops")
  gitops_channel                      = try(local.stack.gitops.channel, "gitops-1.15")
  gitops_git_repo_url                 = try(local.stack.gitops.repository_url, "")
  gitops_target_revision              = try(local.stack.gitops.target_revision, "main")
  gitops_root_app_path                = try(local.stack.gitops.root_app_path, "gitops/overlays/cluster-applications")
  gitops_values                       = local.stack.gitops
  gitops_repo_username                = var.gitops_repo_username
  gitops_repo_password                = var.gitops_repo_password
}
