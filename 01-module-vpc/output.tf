output "vpc_id"{
    value= aws_vpc.main.id
}

output "public_subnet_ids"{
    value= aws_subnet.roboshop-public-subnets[*].id
}

output "private_subnet_ids"{
    value= aws_subnet.roboshop-private-subnets[*].id
}

output "database_subnet_ids"{
    value= aws_subnet.roboshop-database-subnets[*].id
}

