
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.DevOps_practice_ami_id.id
  instance_type = "t3.micro"
  vpc_security_group_ids= data.aws_security_group.bastion.name

  tags = {
    Name="${var.project}-${var.environment}-bastion"
  }
}
