output "vpc_id"{
    value= aws_vpc.main.id
}

output "public_sg_ids"{
    value= aws_subnet.roboshop-public-subnets[*].id
}

output "private_sg_ids"{
    value= aws_subnet.roboshop-private-subnets[*].id
}

output "database_sg_ids"{
    value= aws_subnet.roboshop-database-subnets[*].id
}