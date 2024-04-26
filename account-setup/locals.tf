locals {
  path = "/"
  split_arn = split("/", module.rosa-classic_vpc.vpc_arn)
  vpc_id = element(local.split_arn, length(local.split_arn) - 1)
  # vpc_id = module.rosa-classic_vpc.vpc_id
}