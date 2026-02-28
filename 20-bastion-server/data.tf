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
    name= "bastion-sg_id"
}

