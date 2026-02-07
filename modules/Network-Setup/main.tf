resource "aws_vpc""test"{
  cidr_block = var.vpc_cidr_addr
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
  tags = {
    Name = "My-VPC"
  }
}

resource "aws_subnet" "priv-sub-01"{
  vpc_id = aws_vpc.test.id
  cidr_block = var.private_subnet_cidr_01
  availability_zone = var.az1
  tags = {
    Name = "Private-Subnet-01"
  }
  depends_on = [ aws_vpc.test ]
}

resource "aws_subnet" "priv-sub-02"{
  vpc_id = aws_vpc.test.id
  cidr_block = var.private_subnet_cidr_02
  availability_zone = var.az2
  tags = {
    Name = "Private-Subnet-02"
  }
  depends_on = [ aws_vpc.test ]
}   

resource "aws_subnet" "priv-sub-03"{
  vpc_id = aws_vpc.test.id
  cidr_block = var.private_subnet_cidr_03
  availability_zone = var.az1
  tags = {
    Name = "Private-Subnet-03"
  }
  depends_on = [ aws_vpc.test ]
}

resource "aws_subnet" "priv-sub-04"{
  vpc_id = aws_vpc.test.id
  cidr_block = var.private_subnet_cidr_04
  availability_zone = var.az2
  tags = {
    Name = "Private-Subnet-04"
  }
  depends_on = [ aws_vpc.test ] 
}

resource "aws_internet_gateway" "igw"{
  vpc_id = aws_vpc.test.id
  tags = {
    Name = "My-IGW"
  }
  depends_on = [ aws_vpc.test  ]
}

resource "aws_nat_gateway" "natgw"{
  availability_mode = "regional"
  connectivity_type = "public"
  vpc_id = aws_vpc.test.id
  tags = {
    Name = "My-NATGW"
  }
  depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_route_table" "priv-rtbl-01"{
  vpc_id = aws_vpc.test.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.natgw.id
    }
    tags = {
    Name = "Private-RTBL-01"
  }
    depends_on = [ aws_nat_gateway.natgw ]
}
resource "aws_route_table_association" "priv-rtbl-assoc-01"{
  subnet_id = aws_subnet.priv-sub-01.id
  route_table_id = aws_route_table.priv-rtbl-01.id
  depends_on = [ aws_route_table.priv-rtbl-01 ]
}

resource "aws_route_table" "priv-rtbl-02"{
  vpc_id = aws_vpc.test.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.natgw.id
    }
    tags = {
    Name = "Private-RTBL-02"
  }
    depends_on = [ aws_nat_gateway.natgw ]
}
resource "aws_route_table_association" "priv-rtbl-assoc-02"{
  subnet_id = aws_subnet.priv-sub-02.id
  route_table_id = aws_route_table.priv-rtbl-02.id
  depends_on = [ aws_route_table.priv-rtbl-02 ]     
}

# Create Client-VPN Security Group
resource "aws_security_group" "clientvpn-sg" {
  name        = "clientvpn-sg"
  description = "Security group for Client VPN"
  vpc_id      = aws_vpc.test.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

# Create ALB Security Group
resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.test.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_addr]
    security_groups = [aws_security_group.clientvpn-sg.id]
  } 

  egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
  }

}

# Create EC2 Security Group
resource "aws_security_group" "ec2-sg" {
  name        = "ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.test.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
    }
}


# Create Lambda Security Group
resource "aws_security_group" "lambda-sg" {
  name        = "lambda-sg"
  description = "Security group for Lambda Functions"
  vpc_id      = aws_vpc.test.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
    }
}

# Create RDS Security Group
resource "aws_security_group" "rds-sg" {
  name        = "rds-sg"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.test.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.lambda-sg.id,aws_security_group.ec2-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

# Create SSM Endpoint Security Group
resource "aws_security_group" "ssm-endpoint-sg" {
  name        = "ssm-endpoint-sg"
  description = "Security group for SSM Endpoint"
  vpc_id      = aws_vpc.test.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.test.cidr_block]
    }
  egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Create VPC Endpoints for SSM
resource "aws_vpc_endpoint" "ssm-endpoint" {
  vpc_id            = aws_vpc.test.id
  service_name      = "com.amazonaws.ap-northeast-1.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.priv-sub-01.id]
  security_group_ids = [aws_security_group.ssm-endpoint-sg.id]
  private_dns_enabled = true
  depends_on = [ aws_security_group.ssm-endpoint-sg ]
}

resource "aws_vpc_endpoint" "ssm-messages-endpoint" {
  vpc_id            = aws_vpc.test.id
  service_name      = "com.amazonaws.ap-northeast-1.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.priv-sub-01.id]
  security_group_ids = [aws_security_group.ssm-endpoint-sg.id]
  private_dns_enabled = true
  depends_on = [ aws_security_group.ssm-endpoint-sg ]
}

resource "aws_vpc_endpoint" "ec2messages-endpoint" {
  vpc_id            = aws_vpc.test.id
  service_name      = "com.amazonaws.ap-northeast-1.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.priv-sub-01.id]
  security_group_ids = [aws_security_group.ssm-endpoint-sg.id]
  private_dns_enabled = true
  depends_on = [ aws_security_group.ssm-endpoint-sg ]
}

