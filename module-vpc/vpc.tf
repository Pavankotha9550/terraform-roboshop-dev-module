resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = local.tags
}

resource "aws_internet_gateway" "roboshop-internet-gateway" {
  vpc_id = aws_vpc.main.id
  tags = local.tags
}

resource "aws_subnet" "roboshop-public-subnets" { 
  count= length(var.public_subnets_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnets_cidr[count.index]

  availability_zone=local.az_names[count.index]
  map_public_ip_on_launch= true
  tags = {
    Name= "${local.Name}-${local.az_names[count.index]}-public"
  }
}

resource "aws_subnet" "roboshop-private-subnets" { 
  count= length(var.private_subnets_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnets_cidr[count.index]

  availability_zone=local.az_names[count.index]
  tags = {
    Name= "${local.Name}-${local.az_names[count.index]}-private"
  }
}

resource "aws_subnet" "roboshop-database-subnets" { 
  count= length(var.database_subnets_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnets_cidr[count.index]

  availability_zone=local.az_names[count.index]
  tags = {
    Name= "${local.Name}-${local.az_names[count.index]}-database"
  }
}

resource "aws_eip" "roboshop" {
  domain   = "vpc"
  tags=local.tags
}

resource "aws_nat_gateway" "example" {

  allocation_id = aws_eip.roboshop.id
  subnet_id     = aws_subnet.roboshop-public-subnets[0].id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.roboshop-internet-gateway]
}

resource "aws_route_table" "roboshop-public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "roboshop-public"
  }
}

resource "aws_route_table" "roboshop-private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "roboshop-private"
  }
}
resource "aws_route_table" "roboshop-database" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "roboshop-database"
  }
}

resource "aws_route" "roboshop-public" {
  route_table_id            = aws_route_table.roboshop-public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.roboshop-internet-gateway.id
}

resource "aws_route" "roboshop-private" {
  route_table_id            = aws_route_table.roboshop-private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.example.id
}

resource "aws_route" "roboshop-database" {
  route_table_id            = aws_route_table.roboshop-database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.example.id
}

resource "aws_route_table_association" "roboshop-public" {
  count= length(var.public_subnets_cidr)
  subnet_id      = aws_subnet.roboshop-public-subnets[count.index].id
  route_table_id = aws_route_table.roboshop-public.id
}

resource "aws_route_table_association" "roboshop-private" {
  count= length(var.private_subnets_cidr)
  subnet_id      = aws_subnet.roboshop-private-subnets[count.index].id
  route_table_id = aws_route_table.roboshop-private.id
}

resource "aws_route_table_association" "roboshop-database" {
  count= length(var.database_subnets_cidr)
  subnet_id      = aws_subnet.roboshop-database-subnets[count.index].id
  route_table_id = aws_route_table.roboshop-database.id
}
