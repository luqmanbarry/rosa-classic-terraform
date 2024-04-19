# output "route_tables" {
#   value = data.aws_route_table.subnets_route_tables
# }


output "private_subnet_ids" {
  value = local.private_subnet_ids
}

output "public_subnet_ids" {
  value = local.public_subnet_ids
}