######
# VPC
######
resource "aws_vpc" "this" {
  cidr_block       = "${var.cidr}"
  instance_tenancy = "default"

  tags = "${merge(map("Name", format("%s", var.name)), var.tags)}"
}

###################
# Internet Gateway
###################
resource "aws_internet_gateway" "this" {
  vpc_id = "${aws_vpc.this.id}"

  tags = {
    Name = "IGW"
  }
}

################
# Publiс routes
################
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.this.id}"

  tags = {
    Name = "PUBLIC"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.this.id}"

  timeouts {
    create = "5m"
  }
}

#################
# Private routes
#################
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.this.id}"

  tags = {
    Name = "PRIVATE"
  }
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  instance_id            = "${aws_instance.this.id}"
  depends_on             = ["aws_instance.this"]

  timeouts {
    create = "5m"
  }
}

################
# Public subnet
################
resource "aws_subnet" "public" {
  count = "${length(var.public_subnets)}"

  vpc_id                  = "${aws_vpc.this.id}"
  cidr_block              = "${var.public_subnets[count.index]}"
  availability_zone       = "${element(var.azs, count.index)}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"

  tags = "${merge(map("Name", format("%s-public-%s", var.name, element(var.azs, count.index))), var.tags)}"
}

#################
# Private subnet
#################
resource "aws_subnet" "private" {
  count = "${length(var.private_subnets)}"

  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = "${var.private_subnets[count.index]}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = "${merge(map("Name", format("%s-private-%s", var.name, element(var.azs, count.index))), var.tags)}"
}

##########################
# Route table association
##########################
resource "aws_route_table_association" "private" {
  count = "${length(var.private_subnets)}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route_table_association" "public" {
  count = "${length(var.public_subnets)}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

#########
# EC2 NAT
#########
resource "aws_eip" "nat" {
  vpc      = true
  instance = "${aws_instance.this.id}"

  tags = {
    Name = "NAT"
  }
}

resource "aws_security_group" "nat" {
  name        = "NAT"
  description = "Trafico de internet para el NAT"
  vpc_id      = "${aws_vpc.this.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "NAT"
  }
}

resource "aws_instance" "this" {
  ami                    = "${var.ami}"
  instance_type          = "t2.large"
  subnet_id              = "${element(aws_subnet.public.*.id, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.nat.id}"]
  depends_on             = ["aws_internet_gateway.this", "aws_security_group.nat"]
  source_dest_check      = false

  tags {
    Name = "NAT"
  }
}

resource "aws_security_group" "aws" {
  name        = "AWS"
  description = "Trafico interno AWS"
  vpc_id      = "${aws_vpc.this.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.cidr}"]
  }

  tags {
    Name = "AWS"
  }
}

resource "aws_security_group" "Seidor" {
  name        = "Seidor"
  description = "Trafico RDP a los servidores desde las IPs publicas de Seidor"
  vpc_id      = "${aws_vpc.this.id}"

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["181.224.245.2/32", "170.231.83.234/32", "132.157.130.78/32"]
  }

  tags {
    Name = "Seidor"
  }
}

##############
# VPN Gateway
##############
resource "aws_vpn_gateway" "this" {
  count  = "${var.crear_vpn}"
  vpc_id = "${aws_vpc.this.id}"
}

resource "aws_vpn_gateway_attachment" "this" {
  count          = "${var.crear_vpn}"
  vpc_id         = "${aws_vpc.this.id}"
  vpn_gateway_id = "${var.vpn_gateway_id}"
}

resource "aws_vpn_gateway_route_propagation" "public" {
  count          = "${var.crear_vpn}"
  route_table_id = "${aws_route_table.public.id}"
  vpn_gateway_id = "${aws_vpn_gateway.this.id}"
}

resource "aws_vpn_gateway_route_propagation" "private" {
  count          = "${var.crear_vpn}"
  route_table_id = "${aws_route_table.private.id}"
  vpn_gateway_id = "${aws_vpn_gateway.this.id}"
}

resource "aws_customer_gateway" "this" {
  count      = "${length(var.gateway_cliente)}"
  bgp_asn    = 65000
  ip_address = "${element(var.gateway_cliente, count.index)}"
  type       = "ipsec.1"
}

resource "aws_vpn_connection" "this" {
  count               = "${length(var.gateway_cliente)}"
  vpn_gateway_id      = "${aws_vpn_gateway.this.id}"
  customer_gateway_id = "${aws_customer_gateway.this.*.id}"
  type                = "ipsec.1"
  static_routes_only  = true
}

resource "aws_vpn_connection_route" "this" {
  count                  = "${length(var.static_routes) ? (var.crear_vpn): 0 }"
  destination_cidr_block = "${var.static_routes[count.index]}"
  vpn_connection_id      = "${aws_vpn_connection.this.id}"
}
