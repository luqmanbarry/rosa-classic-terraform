output "vpc_id" {
  value = local.vpc_id
}

output "additional_security_group" {
  value = aws_security_group.ocp_cluster_sg_config.arn
}