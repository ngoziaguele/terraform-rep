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