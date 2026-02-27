variable "cidr_block"{
    default= "10.0.0.0/16"
}

variable "project"{
    type= string
}

variable "environment"{
    type= string
}


variable "public_subnets_cidr" {}
variable "private_subnets_cidr" {}
variable "database_subnets_cidr" {}
