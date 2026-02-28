
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.DevOps_practice_ami_id.id
  instance_type = "t3.micro"
  vpc_security_group_ids= [data.aws_ssm_parameter.bastion.value]
  subnet_id= split("," ,data.aws_ssm_parameter.public_sg_id.value)[0]

  tags = {
    Name="${var.project}-${var.environment}-bastion"
  }
}
