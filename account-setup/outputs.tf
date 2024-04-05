output "vpc_arn" {
  value = module.vpc.vpc_arn
}

output "additional_security_group" {
  value = aws_security_group.ocp_cluster_sg_config.arn
}