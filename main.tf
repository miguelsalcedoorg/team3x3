data "aws_availability_zones" "available" {}
resource "aws_vpc" "myVpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "main" {
 vpc_id      = "${aws_vpc.myVpc.id}"
}

resource "aws_eip" "one" {
  vpc                       = true
}

resource "aws_nat_gateway" "example" {
  connectivity_type = "public"
  subnet_id         = aws_subnet.public[0].id
  allocation_id = aws_eip.one.id
}

resource "aws_subnet" "public" {
  count = 2
  vpc_id      = "${aws_vpc.myVpc.id}"
  availability_zone = data.aws_availability_zones.availability_zones.names[count.index]
  cidr_block = cidrsubnet(aws_vpc.myVpc.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count = 4
  vpc_id      = "${aws_vpc.myVpc.id}"
  availability_zone = data.aws_availability_zones.availability_zones.names[count.index]
  cidr_block = cidrsubnet(aws_vpc.myVpc.cidr_block, 8, count.index + 3)
  map_public_ip_on_launch = true
}


resource "aws_security_group" "SG_LB" {
  name        = "Team-Three-Security-Group"
  description = "Allows security access"
  vpc_id      = "${aws_vpc.myVpc.id}"
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
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.myVpc.id
}

resource "aws_route" "name" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = var.destination_cidr_block
  gateway_id = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count = 2
  subnet_id = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}


data "aws_ami" "aws-ami" {
  most_recent = true
}


resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.myVpc.default_network_acl_id
  
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}