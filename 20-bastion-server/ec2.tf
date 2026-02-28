
resource "aws_instance" "bastion" {
  ami           = data.DevOps_practice_ami_id.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids= data.aws_security_group.bastion.value

  tags = {
    Name="${var.project}-${var.environment}-bastion"
  }
}
