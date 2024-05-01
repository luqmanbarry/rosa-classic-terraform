locals {
  path = "/"
  # split_arn = split("/", module.rosa-classic_account-iam-resources.vpc_arn)
  # vpc_id = element(local.split_arn, length(local.split_arn) - 1)
  account_role_prefix = var.cluster_name
  vpc_id = module.rosa-classic_vpc.vpc_id
}