provider "aws" {
  region = ""
}

resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc-config.cidr_block

  tags = {
    Name = var.vpc-config.name
  }
}

resource "aws_subnet" "subnets" {
  for_each = var.subnet-config
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.az

  tags = {
    Name = each.key
  }
}

resource "aws_internet_gateway" "my-igw" {
  count = length(local.public-subnet) > 0 ? 1 : 0
  vpc_id = aws_vpc.my-vpc.id
}

resource "aws_route_table" "my-rt" {
  count = length(local.public-subnet) > 0 ? 1 : 0
  vpc_id = aws_vpc.my-vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw[0].id
  }
}

resource "aws_route_table_association" "assoc" {
  for_each = local.public-subnet
  subnet_id = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.my-rt[0].id
}