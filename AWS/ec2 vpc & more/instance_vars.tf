variable "region" {
    type = string
    default = "ap-south-1"
}

variable "ami" {
    type = string
    default = "ami-0e6329e222e662a52"
}

variable "inst_type" {
    type = string
    default = "t2.micro"
}

variable "public_ip" {
    type = boolean
    default = true
}
