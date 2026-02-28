resource "aws_security_group" "roboshop-sg" {
  name        = "${var.project}-${var.environment}-${var.server}"
  description = var.description
  vpc_id      = var.vpc_id

  tags = {
    Name="${var.project}-${var.environment}-${var.server}"
    env=var.environment
  }
}