#####################################
#  Create the VPC #
#####################################
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "Gradle-project-vpc"
  }
}

#####################################
# Create the Internet Gateway #
#####################################

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Gradle-igw"
  }
}

#####################################
# Create a Public Subnet (AZ 1a) #
#####################################

resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1a_cidr
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Gradle-EC2-public-1a"
  }
}

##############################################
# Create a Second Public Subnet (AZ 1b) #
#############################################

resource "aws_subnet" "public_1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1b_cidr
  availability_zone       = "ap-south-1b" # Different AZ
  map_public_ip_on_launch = true

  tags = {
    Name = "Gradle-EC2-public-1b"
  }
}

#####################################
#   Create a Route Table AZ-1a #
#####################################
resource "aws_route_table" "public_rt_1a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "Gradle-public-rt-1a"
  }
}


#####################################
# Create a Route Table AZ-1b #
#####################################
resource "aws_route_table" "public_rt_1b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "Gradle-public-rt-1b"
  }
}



##########################################
# Associate Route Table with Subnet AZ-1a #
##########################################

resource "aws_route_table_association" "public_1_assoc" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public_rt_1a.id
}


##########################################
# Associate Route Table with Subnet AZ-1b #
##########################################

resource "aws_route_table_association" "public_2_assoc" {
  subnet_id      = aws_subnet.public_1b.id
  route_table_id = aws_route_table.public_rt_1b.id
}