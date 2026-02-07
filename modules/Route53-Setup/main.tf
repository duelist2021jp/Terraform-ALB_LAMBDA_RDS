resource "aws_route53_zone" "test_private_zone"{
  name = "internal.cloudlab-km.com"
  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "private_dns_a_record"{ 
  zone_id = aws_route53_zone.test_private_zone.zone_id
  name = aws_route53_zone.test_private_zone.name
  type = "A"

  alias {
    name = var.alb_dns_name
    zone_id = var.alb_zone_id
    evaluate_target_health = true
  }
  
  depends_on = [ aws_route53_zone.test_private_zone ]
}

data "aws_route53_zone" "public_zone"{
  name = "cloudlab-km.com"
}

resource "aws_route53_record" "update_record_for_public_zone"{
  zone_id = data.aws_route53_zone.public_zone.zone_id
  name = aws_route53_record.private_dns_a_record.name
  type = "NS"
  ttl = 300
  records = aws_route53_zone.test_private_zone.name_servers

  depends_on = [ data.aws_route53_zone.public_zone ]
}




