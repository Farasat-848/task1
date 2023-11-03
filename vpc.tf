
// In this file
//  1.  Created VPC
//  2.  Created 2 Subnets (Pubic & Private) in same VPC.
//  3.  Created Internet Gateway (connected to that VPC)

//  4.  Created Route Table (for Public Subnet and connected it to the IGW)
//  5.  Associated Public Subnet with Public Route table 


//  1. ============ Creating VPC ==============
//  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
//  ===========================================
resource "aws_vpc" "my_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "MY-VPC"
  }
}

//  2. ========== Creating Public Subnet ==========
//  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
//  ===============================================
resource "aws_subnet" "public_subnet" {
    vpc_id     = aws_vpc.my_vpc.id  // Called interpoltion in tf where you need to give name of vpc in b/w like that
    cidr_block = "10.0.0.0/24"

    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1a"

  tags = {
    Name = "public_subnet"
  }
}

//  2. ========== Creating Private Subnet ==========
//  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
//  =============================================
resource "aws_subnet" "private_subnet" {
    vpc_id     = aws_vpc.my_vpc.id  
    cidr_block = "10.0.1.0/24"

    map_public_ip_on_launch = "false"  // Due to false it shows that private subnet
    availability_zone = "ap-south-1a"

  tags = {
    Name = "Private Subnet"
  }
}

//  3. ========== Creating Internet Gateway ===============
//  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
//  =======================================================
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Internet Gateway"
  }
}

//  4. ========== Creating Route Table (for Public Subnet and connected it to the IGW) ==========
//  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
//  ==============================================================================================
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"  # This is the destination for all public traffic
    gateway_id = aws_internet_gateway.my-igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}


//  5. ======= Assocating Public Subnet with Public Route table =======
//  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
//  ===================================================================
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet.id   // Subnet with which you want to asssociate
  route_table_id = aws_route_table.public_rt.id  // Route Table which you want to asssociate.
}

