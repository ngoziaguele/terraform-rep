resource "aws_vpc" "tuesday-learning" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    tags = {
        Name = "tuesday-learning"
        automated = "yes"
    
    }
}

resource "aws_internet_gateway" "tuesdayigw" {
    vpc_id = aws_vpc.tuesday-learning.id
    tags = {
        Name = "tuesdayigw"
        automated = "yes"
    }    
        
}


resource "aws_subnet" "tuesdaypublicsubnet" {
    count = 3
    vpc_id = aws_vpc.tuesday-learning.id
    cidr_block = element((var.cidrs), count.index)
    availability_zone = element((var.az), count.index)

    # tags = {
    #     Name = "${element(var.public_subnet, count.index)}"
    # }
}

resource "aws_subnet" "tuesdayprivatesubnet" {
    count = 3

    vpc_id = aws_vpc.tuesday-learning.id
    availability_zone = element((var.az), count.index)
    cidr_block = element((var.privatecidrs), count.index)
    
    tags = {
        Name = "${element(var.private_subnet, count.index)}"
    }
}

resource "aws_route_table" "tuesdaypubroute" {
    count = 3
    vpc_id = aws_vpc.tuesday-learning.id
    
    tags = {
        Name = "${element(var.route-names, count.index)}-routes"
    }

}

resource "aws_route" "main" {
    count = 3
    destination_cidr_block = "0.0.0.0/0"
    route_table_id = element(aws_route_table.tuesdaypubroute.*.id, count.index)
    gateway_id = aws_internet_gateway.tuesdayigw.id
}


resource "aws_route_table_association" "pubassociation" {
    count = 3
    subnet_id = element((aws_subnet.tuesdaypublicsubnet.*.id), count.index)
    route_table_id = element(aws_route_table.tuesdaypubroute.*.id, count.index)
}

resource "aws_security_group" "tuesdaysg" {
    name = "allow_tls"
    description = "Allow TLS inbound traffic"
    vpc_id = aws_vpc.tuesday-learning.id

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


resource "aws_instance" "tuesday-learning" {
    count = 3
    ami = "ami-0eb260c4d5475b901"
    key_name = "class2"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.tuesdaysg.id]
    user_data = filebase64("script.sh")
    associate_public_ip_address = true 
    
    subnet_id = element(aws_subnet.tuesdaypublicsubnet.*.id, count.index)


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
    subnet_id = element(aws_subnet.tuesdaypublicsubnet.*.id, count.index)
tags = {
   Name = "${element(var.nat_gateway, count.index)}" 
}


}

# resource "aws_lb_target_group" "test" {
#     name = "tf-tuesdaytargetgroup-lb-tg"
#     port = 80
#     protocol = "HTTP"
#     vpc_id = aws_vpc.tuesday-learning.id
# }


