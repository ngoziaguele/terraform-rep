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