resource "aws_network_interface" "private-eni-01"{
  subnet_id = var.private_subnet_id_01
  security_groups = [ var.ec2_sg_id ]
}

# Create EC2 Instances
resource "aws_instance" "private-ec2-01" {
  ami           = "ami-0b2cd2a95639e0e5b" # Ubuntu Server 24.04 LTS (HVM), SSD Volume Type - for ap-northeast-1
  instance_type = "t3.micro"
  availability_zone = var.az1
  iam_instance_profile = "EC2Instance_Role"
  primary_network_interface {
    network_interface_id = aws_network_interface.private-eni-01.id
  }
  user_data = <<-EOF
    #!/bin/bash
    apt update
    apt dist-upgrade -y
    apt install -y postgresql-client-16
  EOF
  
  tags = {
    Name = "private-ec2-01"
  }
}
