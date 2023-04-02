# Declare the VPC
resource "aws_vpc" "main" {
  cidr_block           = var.main_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "main"
  }
}

# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_route"
  }
}

resource "aws_route_table_association" "public_route_association" {
  count          = length(var.public_cidr_blocks)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table" "private_route" {
  count  = length(aws_subnet.private_subnets)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw[count.index].id
  }
  tags = {
    Name = "private_route_${count.index + 1}"
  }
}

resource "aws_route_table_association" "private-route" {
  count          = length(var.private_cidr_blocks)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route[count.index].id
}

resource "aws_route_table" "db_route" {
  count  = length(aws_subnet.database_subnet)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw[count.index].id
  }
  tags = {
    Name = "db_route_${count.index + 1}"
  }
}

resource "aws_route_table_association" "db-route" {
  count          = length(var.database_subnet_cidr)
  subnet_id      = aws_subnet.database_subnet[count.index].id
  route_table_id = aws_route_table.db_route[count.index].id
}
