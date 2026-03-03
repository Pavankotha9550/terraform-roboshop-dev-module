data "aws_ami" "DevOps_practice_ami_id" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["973714476881"] 
}

data "aws_ssm_parameter" "bastion"{
    name= "/${var.project}/${var.environment}/bastion-sg_id"
}

data "aws_ssm_parameter" "public_subnet_id"{
    name= "/${var.project}/${var.environment}/public_subnet_ids"
}

