resource "aws_vpc" "tuesday-learning" {
    cidr_block = "192.168.0.0/24"
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
    count = 2
    vpc_id = aws_vpc.tuesday-learning.id
    cidr_block = element((var.cidrs), count.index)
    availability_zone = element((var.az), count.index)

    tags = {
        Name = "tuesdaypublicsubnet"
    }
}

resource "aws_subnet" "tuesdayprivatesubnet" {
    vpc_id = aws_vpc.tuesday-learning.id
    
    cidr_block = "192.168.0.16/28"
    tags = {
        Name = "tuesdayprivatesubnet"
    }
}

resource "aws_route_table" "tuesdaypubroute" {
    count = 2
    vpc_id = aws_vpc.tuesday-learning.id
    
    tags = {
        Name = "${element(var.route-names, count.index)}-routes"
    }

}

resource "aws_route" "main" {
    count = 2
    destination_cidr_block = "0.0.0.0/0"
    route_table_id = element(aws_route_table.tuesdaypubroute.*.id, count.index)
    gateway_id = aws_internet_gateway.tuesdayigw.id
}


resource "aws_route_table_association" "pubassociation" {
    count = 2
    subnet_id = element((aws_subnet.tuesdaypublicsubnet.*.id), count.index)
    route_table_id = element(aws_route_table.tuesdaypubroute.*.id, count.index)
}

resource "aws_security_group" "tuesdaysg" {
    name = "allow_tls"
    description = "Allow TLS inbound traffic"
    vpc_id = aws_vpc.tuesday-learning.id

    ingress{
        description = "HTTP from VPC"
        from_port   = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

}
