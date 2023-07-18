resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    tags = {
        Name = "main"
        automated = "yes"
    
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "main"
        automated = "yes"
    }    
        
}


resource "aws_subnet" "main_public" {
    count = 3
    vpc_id = aws_vpc.main.id
    cidr_block = element((var.cidrs), count.index)
    availability_zone = element((var.az), count.index)

    # tags = {
    #     Name = "${element(var.public_subnet, count.index)}"
    # }
}

resource "aws_subnet" "main_private" {
    count = 3

    vpc_id = aws_vpc.main.id
    availability_zone = element((var.az), count.index)
    cidr_block = element((var.privatecidrs), count.index)
    
    tags = {
        Name = "${element(var.private_subnet, count.index)}"
    }
}

resource "aws_route_table" "main" {
    count = 3
    vpc_id = aws_vpc.main.id
    
    tags = {
        Name = "${element(var.route-names, count.index)}-routes"
    }

}

resource "aws_route" "main" {
    count = 3
    destination_cidr_block = "0.0.0.0/0"
    route_table_id = element(aws_route_table.main.*.id, count.index)
    gateway_id = aws_internet_gateway.main.id
}


resource "aws_route_table_association" "main" {
    count = 3
    subnet_id = element((aws_subnet.main_public.*.id), count.index)
    route_table_id = element(aws_route_table.main.*.id, count.index)
}

resource "aws_security_group" "main" {
    name = "allow_tls"
    description = "Allow TLS inbound traffic"
    vpc_id = aws_vpc.main.id

    ingress {
        description = "HTTP from VPC"
        from_port   = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTPS from VPC"
        from_port   = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SSH from VPC"
        from_port   = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


    egress {
        description = "access to the internet"
        from_port  = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_instance" "main" {
    count = 3
    ami = "ami-0eb260c4d5475b901"
    key_name = "class2"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.main.id]
    user_data = filebase64("script.sh")
    associate_public_ip_address = true 
    
    subnet_id = element(aws_subnet.main_public.*.id, count.index)


    tags = {
        Name = "${element(var.public_subnet, count.index)}-instance"
    }
}

resource "aws_eip" "lb"  {
    count = 3
    vpc = true
}

resource "aws_nat_gateway" "main" {
    count = 3
    allocation_id = element(aws_eip.lb.*.id, count.index)
    subnet_id = element(aws_subnet.main_public.*.id, count.index)
    tags = {
        Name = "${element(var.nat_gateway, count.index)}" 
}


}

resource "aws_lb_target_group" "main" {
     name = "tf-main-lb-tg"
     port = 80
     protocol = "HTTP"
     vpc_id = aws_vpc.main.id
 }

resource "aws_lb_target_group_attachment" "main" {
    count = 3
    target_group_arn = "${aws_lb_target_group.main.arn}"
    target_id = element(aws_instance.main.*.id, count.index)
    port = 80

}

resource "aws_lb" "main" {
    name = "main-lb-tf"
    load_balancer_type = "application"
    security_groups = [aws_security_group.main.id]
    subnets = [for subnet in aws_subnet.main_public : subnet.id]

}

#resource "aws_acm_certificate" "cert" {
    #domain_name = "*.teddxo.com" 
   # validation_method = "DNS"

   # lifecycle {
      #  create_before_destroy = true
   #}
#}

#data "aws_route53_zone" "public" {
 #   name         = "teddxo.com"
  #  private_zone = false
#}

#resource "aws_route53_record" "example" {
 # for_each = {
  #  for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
   #   name   = dvo.resource_record_name
    #  record = dvo.resource_record_value
     # type   = dvo.resource_record_type
    #}
  #}



#resource "aws_lb_listener" "main" {
  #load_balancer_arn = aws_lb.main.arn
  #port              = "443"
  #protocol          = "HTTPS"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  #default_action {
    #type             = "forward"
    #target_group_arn = aws_lb_target_group.front_end.arn
  #}
#}