# --- AZ-1 (Index 0 of our list) ---
resource "aws_subnet" "public_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 1)
  availability_zone = var.azs[0] # Takes "us-east-1a"
  tags              = { Name = "Public-Subnet-AZ1" }
}

resource "aws_subnet" "app_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 10)
  availability_zone = var.azs[0]
  tags              = { Name = "App-Subnet-AZ1" }
}

# --- AZ-2 (Index 1 of our list) ---
resource "aws_subnet" "public_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 2)
  availability_zone = var.azs[1] # Takes "us-east-1b"
  tags              = { Name = "Public-Subnet-AZ2" }
}

resource "aws_subnet" "app_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 11)
  availability_zone = var.azs[1]
  tags              = { Name = "App-Subnet-AZ2" }
}