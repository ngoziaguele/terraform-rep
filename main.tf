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
    vpc_id = aws_vpc.tuesday-learning.id
    cidr_block = "192.168.0.0/28"

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
    vpc_id = aws_vpc.tuesday-learning.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.tuesdayigw.id
    }
}