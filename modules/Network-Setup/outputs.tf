output "vpc_id" {
  value = aws_vpc.test.id
}

output "private_subnet_id_01" {
  value = aws_subnet.priv-sub-01.id
}

output "private_subnet_id_02" {
  value = aws_subnet.priv-sub-02.id
}

output "private_subnet_id_03" {
  value = aws_subnet.priv-sub-03.id
}

output "private_subnet_id_04"{
  value = aws_subnet.priv-sub-04.id
}

output "ec2_sg_id" {
  value = aws_security_group.ec2-sg.id
}

output "lambda_sg_id" {
  value = aws_security_group.lambda-sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds-sg.id
}

output "alb_sg_id" {
  value = aws_security_group.alb-sg.id
}