resource "aws_vpc" "tuesday-learning" {
    cidr_block = "192.168.0.0/24"
    instance_tenancy = "default"
    tags = {
        Name = "tuesday-learning"
    
    }
}