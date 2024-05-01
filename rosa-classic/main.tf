data "aws_caller_identity" "current" {}

resource "random_string" "random_name" {
  length           = 6
  special          = false
  upper            = false
}

resource "rhcs_cluster_rosa_classic" "rosa_sts_cluster" {
  depends_on           = [ time_sleep.wait_for_oidc ]

  name                 = local.cluster_name
  cloud_region         = var.aws_region
  multi_az             = ((length(var.private_subnet_ids) > 2 || length(var.private_subnet_ids) > 2) ? true : false)
  aws_account_id       = data.aws_caller_identity.current.account_id
  availability_zones   = sort(toset(var.availability_zones))
  version              = var.ocp_version

  proxy                = (var.proxy.enable ? var.proxy : null)

  compute_machine_type = var.machine_type
  replicas             = local.worker_node_replicas
  autoscaling_enabled  = var.autoscaling_enabled
  default_mp_labels    = length(var.default_mp_labels) > 0 ? var.default_mp_labels : null
 
  min_replicas         = var.autoscaling_enabled ? var.min_replicas : null
  max_replicas         = var.autoscaling_enabled ? var.max_replicas : null

  aws_additional_compute_security_group_ids         = var.aws_additional_compute_security_group_ids
  aws_additional_control_plane_security_group_ids   = var.aws_additional_control_plane_security_group_ids
  aws_additional_infra_security_group_ids           = var.aws_additional_infra_security_group_ids

  disable_scp_checks = false
  disable_workload_monitoring = false
  
  sts                  = local.sts_roles

  properties = {
    rosa_creator_arn = data.aws_caller_identity.current.arn
  }

  admin_credentials      = {
    username = local.username
    password = local.password
  }

  ## Private link settings
  private          = var.private_cluster
  aws_private_link = var.private_cluster
  aws_subnet_ids   = var.private_cluster ? var.private_subnet_ids : concat(var.private_subnet_ids, var.public_subnet_ids)
  machine_cidr     = var.vpc_cidr_block
  pod_cidr         = var.pod_cidr
  service_cidr     = var.service_cidr

  lifecycle {
    precondition {
      condition     = can(regex("^[a-z-0-9]{6,15}$", local.cluster_name))
      error_message = "ROSA cluster name must be between 6 and 15 characters, be lower case alphanumeric, with only hyphens."
    }
  }

  tags = var.additional_tags
}

resource "rhcs_cluster_wait" "wait_for_cluster_build" {
  cluster = rhcs_cluster_rosa_classic.rosa_sts_cluster.id
  # timeout in minutes
  timeout = 60
}