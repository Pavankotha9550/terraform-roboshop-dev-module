locals {
    vpc_zone_identifier= var.component == "frontend" ? split("," ,data.aws_ssm_parameter.public_subnet_id.value) : split("," ,data.aws_ssm_parameter.private_subnet_id.value)
    #listener_arn = var.component == "frontend" ? data.aws_ssm_parameter.flb-ARN.value : data.aws_ssm_parameter.alb-ARN.value
    port = var.component == "frontend" ? 80 : 8080
    component= var.component
    #vpc_security_group_ids= data.aws_ssm_parameter.local.component.value
    #host = aws_instance.${local.component}.private_ip
    listener_arns= var.component == "frontend" ? data.aws_ssm_parameter.flb-ARN-lisitner.value : data.aws_ssm_parameter.alb-ARN-lisitner.value
    subnet = var.component == "frontend" ? split("," ,data.aws_ssm_parameter.public_subnet_id.value)[0] : split("," ,data.aws_ssm_parameter.private_subnet_id.value)[0]
    protocol= var.component == "frontend" ? "HTTPS" : "HTTP"

    name= var.component == "frontend" ? "${var.zone_name}": "${var.component}.${var.zone_name}"
}