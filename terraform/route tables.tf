# TABLE FOR PUBLIC SUBNETS
resource "aws_route_table" "pub-table" {
  vpc_id = "${aws_vpc.ecs-vpc.id}"
  tags = {
    Name = "Public-Route"
  }
}


resource "aws_route" "pub-route" {
  route_table_id         = "${aws_route_table.pub-table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.i-gateway.id}"
}

resource "aws_route_table_association" "as-pub" {
  count          = length(var.azs)
  route_table_id = "${aws_route_table.pub-table.id}"
  subnet_id      = "${aws_subnet.pub-subnets[count.index].id}"
}

# TABLE FOR Private SUBNETS

resource "aws_route_table" "private-table" {
  vpc_id = "${aws_vpc.ecs-vpc.id}"
  tags = {
    Name = "Private-Route"
  }
}




resource "aws_route_table_association" "as-private" {
  count          = length(var.azs)
  route_table_id = "${aws_route_table.private-table.id}"
  subnet_id      = "${aws_subnet.private-subnets[count.index].id}"
}




# TABLE FOR Nated SUBNETS

resource "aws_route_table" "nated-table" {
  vpc_id = "${aws_vpc.ecs-vpc.id}"
  tags = {
    Name = "Nated-Route"
  }
}


resource "aws_route" "nated-route" {
  route_table_id         = "${aws_route_table.nated-table.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id          = "${aws_nat_gateway.gw.id}"
}

resource "aws_route_table_association" "as-nated" {
  count          = length(var.azs)
  route_table_id = "${aws_route_table.nated-table.id}"
  subnet_id      = "${aws_subnet.nated-subnets[count.index].id}"
}