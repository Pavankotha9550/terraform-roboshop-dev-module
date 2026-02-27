resource "aws_security_group" "roboshop-sg" {
  name        = "${var.project}-${var.environment}-frontend"
  description = var.description
  vpc_id      = var.vpc_id

  tags = {
    Name="${var.project}-${var.environment}-frontend"
    env=var.environment
  }
}