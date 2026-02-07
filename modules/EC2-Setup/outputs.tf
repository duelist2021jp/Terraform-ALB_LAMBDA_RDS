output "private_instance_01_id" {
    description = "The private Instance ID of the first EC2 instance"
    value       = aws_instance.private-ec2-01.id
}

