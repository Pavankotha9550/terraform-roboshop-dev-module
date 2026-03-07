locals {
    vpc_security_group_ids = var.component == "frontend" ? split("," ,data.aws_ssm_parameter.public_subnet_id.value)[0] : split("," ,data.aws_ssm_parameter.private_subnet_id.value)[0]
    vpc_zone_identifier= var.component == "frontend" ? split("," ,data.aws_ssm_parameter.public_subnet_id.value) : split("," ,data.aws_ssm_parameter.private_subnet_id.value)
    listener_arn = var.component == "frontend" ? data.aws_ssm_parameter.flb-ARN.value : data.aws_ssm_parameter.alb-ARN.value
    port = var.component == "frontend" ? 80 : 8080
    component= var.component
    #vpc_security_group_ids= data.aws_ssm_parameter.local.component.value
    host = aws_instance.${local.component}.private_ip
}