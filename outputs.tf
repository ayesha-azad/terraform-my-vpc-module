output "vpc-id" {
  description = "The ID of the VPC"
  value       = aws_vpc.my-vpc.id
}

output "vpc-cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.my-vpc.cidr_block
}

output "public-subnet" {
  description = "Map of public subnets with their configurations"
  value       = local.public-subnet
}

output "private-subnet" {
  description = "Map of private subnets with their configurations"
  value       = local.private-subnet
}

output "internet-gateway-id" {
  description = "The ID of the Internet Gateway (if public subnets exist)"
  value       = length(aws_internet_gateway.my-igw) > 0 ? aws_internet_gateway.my-igw[0].id : null
}

output "route-table-id" {
  description = "The ID of the route table for public subnets (if public subnets exist)"
  value       = length(aws_route_table.my-rt) > 0 ? aws_route_table.my-rt[0].id : null
}
