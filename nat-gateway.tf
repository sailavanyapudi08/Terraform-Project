# NAT Gateway for Private Subnets
resource "aws_eip" "nat" {}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet_az1.id
}

# Add a second NAT Gateway in AZ2
resource "aws_eip" "nat_az2" {}

resource "aws_nat_gateway" "nat_az2" {
  allocation_id = aws_eip.nat_az2.id
  subnet_id     = aws_subnet.public_subnet_az2.id
}