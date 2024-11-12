######################################################
# Infrastructure VPC Configuration for Network Account
######################################################

# Fetch Current Region & Availability Zones
data "aws_region" "current" {}

data "aws_availability_zones" "available" {}


resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.prefix}-vpc"
  }
}

# Internet Gateway

resource "aws_internet_gateway" "infra_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.prefix}-infra-igw"
  }
}

######################################################
# Public Subnets
######################################################
resource "aws_subnet" "public_subnets" {
  for_each = {
    "a" = {
      cidr_block        = var.public_cidr_blocks[0]
      availability_zone = var.azs[0]
    }
    "b" = {
      cidr_block        = var.public_cidr_blocks[1]
      availability_zone = var.azs[1]
    }
  }

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = true
  availability_zone       = each.value.availability_zone

  tags = {
    Name = "${var.prefix}-public-sub-${each.key}"
  }
}

# Public Route Table
resource "aws_route_table" "public_rts" {
  for_each = aws_subnet.public_subnets
  vpc_id   = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.infra_igw.id
  }

  tags = {
    Name = "${var.prefix}-public-rt-${each.key}"
  }
}

# Route Table Associations for Public Subnets
resource "aws_route_table_association" "public_rta" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rts[each.key].id
}


######################################################
# Private Subnets
######################################################
resource "aws_subnet" "private_subnets" {
  for_each = {
    "a" = {
      cidr_block        = var.private_cidr_blocks[0]
      availability_zone = var.azs[0]
    }
    "b" = {
      cidr_block        = var.private_cidr_blocks[1]
      availability_zone = var.azs[1]
    }
  }

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = false
  availability_zone       = each.value.availability_zone

  tags = {
    Name = "${var.prefix}-private-sub-${each.key}"
  }
}


# Private Route Table
resource "aws_route_table" "private_rts" {
  for_each = aws_subnet.private_subnets
  vpc_id   = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.prefix}-private-rt-${each.key}"
  }
}



# Route Table Associations for Private Subnets
resource "aws_route_table_association" "private_rta" {
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rts[each.key].id
}
