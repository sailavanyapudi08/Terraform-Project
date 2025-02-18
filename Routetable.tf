# Route Tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.web_vpc.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public_assoc_az1" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_az2" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_rt.id
}

# Update private route tables to use the NAT Gateway in their AZ
resource "aws_route_table" "private_rt_az1" {
  vpc_id = aws_vpc.web_vpc.id
}

resource "aws_route" "private_internet_access_az1" {
  route_table_id         = aws_route_table.private_rt_az1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id  # AZ1 NAT
}

resource "aws_route_table" "private_rt_az2" {
  vpc_id = aws_vpc.web_vpc.id
}

resource "aws_route" "private_internet_access_az2" {
  route_table_id         = aws_route_table.private_rt_az2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_az2.id  # AZ2 NAT
}

# Associate subnets with their respective route tables
resource "aws_route_table_association" "private_assoc_az1" {
  subnet_id      = aws_subnet.private_subnet_az1.id
  route_table_id = aws_route_table.private_rt_az1.id
}

resource "aws_route_table_association" "private_assoc_az2" {
  subnet_id      = aws_subnet.private_subnet_az2.id
  route_table_id = aws_route_table.private_rt_az2.id
}
