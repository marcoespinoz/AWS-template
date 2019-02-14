#####
# DNS
#####
resource "aws_route53_zone" "this" {
  name = "inkafarma.internal"

  vpc {
    vpc_id = "${aws_vpc.this.id}"
  }
}

######
# DHCP
######
resource "aws_vpc_dhcp_options" "this" {
  domain_name = "inkafarma.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags = {
    Name = "inkafarma"
  }
}

######
# VPC
######
resource "aws_vpc" "this" {
  cidr_block       = "${var.cidr}"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  enable_dns_support =   "true"

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = "${aws_vpc.this.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.this.id}"
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
  nat_gateway_id         = "${aws_nat_gateway.nat_gw.id}"

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
  tags {
      Name = "Public-${count.index}"
  }
}

#################
# Private subnet
#################
resource "aws_subnet" "private" {
  count = "${length(var.private_subnets)}"

  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = "${var.private_subnets[count.index]}"
  availability_zone = "${element(var.azs, count.index)}"
  tags {
      Name = "Private-${count.index}"
  }
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

#############
# NAT GATEWAY
#############

resource "aws_eip" "nat" {
  vpc = true

  tags {
    Name = "IP NAT"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
}
/*
##################
# SECURITY GROUPS
##################

resource "aws_security_group" "this" {
  name        = "AWS internal"
  description = "Allow internal traffic"
  vpc_id      = "${aws_vpc.this.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.cidr}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]

  }
  tags {
    Name = "AWS"
  }
}
*/
