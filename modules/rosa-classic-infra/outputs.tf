output "vpc_id" {
  value = local.vpc_id
}

output "vpc_cidr_block" {
  value = module.rosa-classic_vpc.cidr_block
}

output "private_subnet_ids" {
  value = module.rosa-classic_vpc.private_subnets
}

output "public_subnet_ids" {
  value = module.rosa-classic_vpc.public_subnets
}

output "availability_zones" {
  value = module.rosa-classic_vpc.availability_zones
}

output "hosted_zone_id" {
  value = aws_route53_zone.base_dns_domain.zone_id
}

output "additional_security_group" {
  value = aws_security_group.ocp_cluster_sg_config.arn
}
