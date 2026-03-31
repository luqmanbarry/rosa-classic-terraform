terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.31"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

locals {
  oidc_issuer_hostpath = replace(var.oidc_endpoint_url, "https://", "")
  oidc_provider_arn    = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_issuer_hostpath}"
  roles                = var.enabled ? var.roles : {}
}

data "aws_iam_policy_document" "assume_role" {
  for_each = local.roles

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_issuer_hostpath}:aud"
      values   = [var.oidc_audience]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_issuer_hostpath}:sub"
      values = [
        "system:serviceaccount:${each.value.namespace}:${each.value.service_account}",
      ]
    }
  }
}

resource "aws_iam_role" "workload_identity" {
  for_each = local.roles

  name = coalesce(
    try(each.value.role_name, null),
    "${var.cluster_name}-${each.key}"
  )

  description        = try(each.value.description, "AWS workload identity role for ${each.key} on ${var.cluster_name}.")
  path               = try(each.value.path, "/")
  assume_role_policy = data.aws_iam_policy_document.assume_role[each.key].json

  tags = merge(
    var.additional_tags,
    try(each.value.tags, {}),
    {
      cluster_name    = var.cluster_name
      identity_name   = each.key
      service_account = each.value.service_account
      namespace       = each.value.namespace
    }
  )
}

resource "aws_iam_role_policy_attachment" "managed_policies" {
  for_each = {
    for item in flatten([
      for role_name, role in local.roles : [
        for policy_arn in try(role.managed_policy_arns, []) : {
          key       = "${role_name}:${policy_arn}"
          role_name = role_name
          policy    = policy_arn
        }
      ]
    ]) : item.key => item
  }

  role       = aws_iam_role.workload_identity[each.value.role_name].name
  policy_arn = each.value.policy
}

resource "aws_iam_role_policy" "inline_policy" {
  for_each = {
    for role_name, role in local.roles : role_name => role
    if try(trim(role.inline_policy_json) != "", false)
  }

  name   = "${aws_iam_role.workload_identity[each.key].name}-inline"
  role   = aws_iam_role.workload_identity[each.key].id
  policy = each.value.inline_policy_json
}
