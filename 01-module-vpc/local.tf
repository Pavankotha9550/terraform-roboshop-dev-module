locals {
    Name= "${var.project}-${var.environment}"
    project=var.project
    environment=var.environment
    tags=merge({Name=local.Name},{project=var.project},
    {environment=var.environment} )
    az_names=slice(data.aws_availability_zones.available.names,0,2)
}