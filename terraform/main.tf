# =====================================================
# 1. THE BUILDING (VPC)
# =====================================================
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "petclinic-vpc" }
}

# =====================================================
# 2. BUILDING A (Availability Zone: us-east-1a)
# =====================================================

# Floor 1: Public (For Load Balancer)
resource "aws_subnet" "public_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "Public-Subnet-AZ1-LB-1" }
}

# Floor 2: Private (For App/EC2)
resource "aws_subnet" "private_app_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "Private-EC2-AZ1" }
}

# Floor 3: Private (For Database/RDS)
resource "aws_subnet" "private_db_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "us-east-1a"
  tags = { Name = "Private-DB-AZ1" }
}

# =====================================================
# 3. BUILDING B (Availability Zone: us-east-1b)
# =====================================================

# Floor 1: Public (For Load Balancer)
resource "aws_subnet" "public_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = { Name = "Public-Subnet-AZ2-LB" }
}

# Floor 2: Private (For App/EC2)
resource "aws_subnet" "private_app_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-east-1b"
  tags = { Name = "Private-EC2-AZ2" }
}

# Floor 3: Private (For Database/RDS)
resource "aws_subnet" "private_db_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = "us-east-1b"
  tags = { Name = "Private-DB-AZ2" }
}

# =====================================================
# aws_internet_gateway which is attached main VPC 
# =====================================================

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "PetClinic-IGW" }
}


# =====================================================
# aws_internet_gateway which is attached main VPC 
# =====================================================

# The Static IP for the NAT
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags   = { Name = "PetClinic-NAT-EIP" }
}

# The NAT Gateway itself (Lives in Public AZ1)
resource "aws_nat_gateway" "main_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_az1.id 
  tags          = { Name = "Main-NAT-Gateway" }

  depends_on = [aws_internet_gateway.igw]
}

