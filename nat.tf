
// In this file
//  1. First Created Elastic IP for the NAT Gateway.
//  2. Then Created NAT Gateway.

//  3.  Creating Route Table (for Private Subnet)
//  4.  Associated Private Subnet with Private Route table



//  1. ==== First Create Elastic IP for the NAT Gateway. ====
resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [ aws_internet_gateway.my-igw ]

  tags = {
    Name = "My NAT Gateway"
  }
}

//  2. ==== Creating NAT Gateway =====
resource "aws_nat_gateway" "my_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id // As Creating NAT in public ssubnet

  tags = {
    Name = "NAT Gateway"
  }
}


//  3. ==== Creating Route Table (for Private Subnet) and then mentioning the NAT Gateway Path in that Route Table.
//  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
//  =================================================================================================================
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_nat_gateway.my_nat.id
  }

  tags = {
    Name = "Private Route Table"
  }
}


//  4. ======= Assocating Private Subnet with Private Route table =======
//  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
//  =================================================================================================================
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id   // Subnet with which you want to asssociate.
  route_table_id = aws_route_table.private_rt.id  // Route Table which you want to asssociate.
}


