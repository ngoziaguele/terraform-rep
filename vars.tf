variable "az" {
    description = "avalability zone"
    default = ["eu-west-2a", "eu-west-2b"]
    type = list(string)
}

variable "route-names" {
    description = "route names"
    default = ["public1", "public2"]
    type = list(string)
}

variable "cidrs" {
    description = "cidr block"
    default = ["192.168.0.0/28", "192.168.0.32/28"]
    type = list(string)
}

variable "vpc_cidr" {
    description = "vpc cidr block"
    default = "192.168.0.0/24"
    type = string

}
variable "public_subnet" {
    description = "public subnets"
    default = ["public-subnet1", "public-subnet2"]
    type = list(string)
}