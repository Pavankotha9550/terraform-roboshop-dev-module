output "arn"{
    data.aws_ssm_parameter.alb-ARN.value
}