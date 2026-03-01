resource "aws_security_group" "roboshop-sg" {
  name        = "${var.project}-${var.environment}-${var.server}"
  description = var.description
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  tags = {
    Name="${var.project}-${var.environment}-${var.server}"
    env=var.environment
  }
}

