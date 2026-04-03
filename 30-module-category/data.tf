data "aws_ssm_parameter" "catalogue" {
  name = "/${var.project}/${var.environment}/catalogue-sg_id"
}



data "aws_ssm_parameter" "private_subnet_id"{
    name= "/${var.project}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "public_subnet_id"{
    name= "/${var.project}/${var.environment}/public_subnet_ids"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.environment}/vpc_id"
}

data "aws_route53_zone" "daws84" {
  name         = "daws84.cyou"
}

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


data "aws_ssm_parameter" "alb-ARN-lisitner"{
name= "/${var.project}/${var.environment}/alb-ARN-lisitner"
}

data "aws_ssm_parameter" "flb-ARN-lisitner"{
name= "/${var.project}/${var.environment}/flb-ARN-lisitner"
}

data "aws_ssm_parameter" "sg_id"{
name= "/${var.project}/${var.environment}/${var.component}-sg_id"
}

