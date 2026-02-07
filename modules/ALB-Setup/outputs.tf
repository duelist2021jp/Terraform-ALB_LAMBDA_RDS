output "alb-dns"{
  value = aws_lb.my-alb.dns_name
}

output "alb-zone-id"{
  value = aws_lb.my-alb.zone_id
}