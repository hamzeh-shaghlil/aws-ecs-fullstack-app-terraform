resource "aws_vpc" "ecs-vpc" {
  cidr_block = "${var.cidr}"

  tags = {
    Name = "ecs-vpc"
  }
}

# Private SUBNETS
resource "aws_subnet" "private-subnets" {
  count                   = length(var.azs)
  vpc_id                  = "${aws_vpc.ecs-vpc.id}"
  availability_zone       = "${var.azs[count.index]}"
  cidr_block              = "${var.private-subnets-ip[count.index]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "private-subnets"
  }
}


# PUBLIC SUBNETS
resource "aws_subnet" "pub-subnets" {
  count                   = length(var.azs)
  vpc_id                  = "${aws_vpc.ecs-vpc.id}"
  availability_zone       = "${var.azs[count.index]}"
  cidr_block              = "${var.public-subnets-ip[count.index]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "pub-subnets"
  }
}


# Nated SUBNETS
resource "aws_subnet" "nated-subnets" {
  count                   = length(var.azs)
  vpc_id                  = "${aws_vpc.ecs-vpc.id}"
  availability_zone       = "${var.azs[count.index]}"
  cidr_block              = "${var.nated-subnets-ip[count.index]}"


  tags = {
    Name = "nated-subnets"
  }
}


# INTERNET GATEWAY
resource "aws_internet_gateway" "i-gateway" {
  vpc_id = "${aws_vpc.ecs-vpc.id}"

  tags = {
    Name = "ecs-igtw"
  }
}

# Elastic IP for GATEWAY
resource "aws_eip" "nat" {
  vpc      = true
}

# NAT GATEWAY
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = "${aws_subnet.pub-subnets[0].id}"

  tags = {
    Name = "gw NAT"
  }
   
}
