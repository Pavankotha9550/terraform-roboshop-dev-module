resource "aws_instance" "main" {
  ami           = data.aws_ami.DevOps_practice_ami_id.id
  instance_type = "t3.micro"
  vpc_security_group_ids= [data.aws_ssm_parameter.sg_id.value]
  subnet_id= local.subnet
  #iam_instance_profile= "EC2RoleToFetchSSMParameter"
  
  
  tags = {
    Name="${var.project}-${var.environment}-${var.component}"
  }
}

/*resource "aws_route53_record" "catalogue" {
  zone_id =  data.aws_route53_zone.daws84.zone_id
  name    = "${var.server}.daws84.cyou"
  type    = "A"
  ttl = 1
  records= [aws_instance.catalogue.private_ip]
  allow_overwrite= true
}*/

resource "terraform_data" "main"{
  triggers_replace=[
    aws_instance.main.id
  ]

  provisioner "file"{
    source= "bootstrap.sh"
    destination= "/tmp/bootstrap.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.main.private_ip
  }

   provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh ${var.component}"
    ]
  }
}

resource "aws_ec2_instance_state" "main" {
  instance_id = aws_instance.main.id
  state       = "stopped"
  depends_on = [terraform_data.main]
}

resource "aws_ami_from_instance" "main" {
  name               = "${var.project}-${var.environment}-${var.component}"
  source_instance_id = aws_instance.main.id
  depends_on = [aws_ec2_instance_state.main]
  tags = {
      Name = "${var.project}-${var.environment}-${var.component}"
    }

}

resource "terraform_data" "main_delete" {
  triggers_replace = [
    aws_instance.main.id
  ]
  
  # make sure you have aws configure in your laptop
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.main.id}"
  }

  depends_on = [aws_ami_from_instance.main]
}

resource "aws_launch_template" "main" {
  name= "${var.component}.${var.zone_name}"
  image_id = aws_ami_from_instance.main.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.sg_id.value]
  update_default_version = true

  tag_specifications {
    resource_type = "instance"
    # EC2 tags created by ASG
    tags = {
        Name = "${var.project}-${var.environment}-${var.component}"
      }  
  }

  tag_specifications {
    resource_type = "volume"
    # EC2 tags created by ASG
    tags ={
        Name = "${var.project}-${var.environment}-${var.component}"
      }  
  }

  tags ={
    Name= "${var.project}-${var.environment}-${var.component}"
  }
}

resource "aws_autoscaling_group" "main" {
  name     = "${var.component}.${var.zone_name}"
  max_size                  = 10
  min_size                  = 1
  health_check_grace_period = 100
  health_check_type         = "ELB"
  desired_capacity          = 1
  vpc_zone_identifier       = local.vpc_zone_identifier  
  target_group_arns =[aws_lb_target_group.main.arn]


  launch_template {
    id      = aws_launch_template.main.id
    version = aws_launch_template.main.latest_version
  }

  dynamic "tag" {
    for_each = {
        Name = "${var.project}-${var.environment}-${var.component}"
      }

    content{
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
    
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

   timeouts{
    delete = "15m"
  }

}

resource "aws_autoscaling_policy" "main" {
  name                   = "${var.component}.${var.zone_name}"
  scaling_adjustment     = 1
  policy_type       = "TargetTrackingScaling"
  #instance_warmup = 100
  #cooldown               = 100 this dosent work here
  autoscaling_group_name = aws_autoscaling_group.main.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 80.0
  }
}

resource "aws_lb_listener_rule" "main" {
  listener_arn = local.listener_arns
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    host_header {
      values = ["${var.component}.daws84.cyou"]
    }
  }
}

resource "aws_lb_target_group" "main" {
  name     = "${var.project}-${var.environment}-${var.component}"
  port     = local.port
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value
  deregistration_delay = 120 #time giving to instance to complete all the pending requests to complete 

  health_check{
    healthy_threshold =2 
    interval = 5
    matcher = "200-299"
    path = "/health"
    port = 8080
    timeout= 2
    unhealthy_threshold =3
  }
}
