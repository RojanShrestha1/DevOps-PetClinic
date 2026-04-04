
# 1. Fetch the latest Ubuntu 24.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_launch_template" "gradle_lt" {
  name_prefix   = "${var.project_name}-lt"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "My_cloud"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.ec2_sg_id] # Use the ID of your ec2_sg here
  }

  # THIS IS THE PART YOU ARE UPDATING
  user_data = base64encode(<<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y ansible
              
              # This part writes your playbook.yml onto the server's hard drive
              cat << 'PBOOK' > /tmp/playbook.yml
              ${file("${path.module}/playbook.yml")}
              PBOOK

              # This part tells Ansible to read that file and start Docker
              ansible-playbook /tmp/playbook.yml
              EOF
  )

  # ... other settings like network_interfaces or monitoring ...
}

# 3. The Auto Scaling Group (ASG) - Merged & Final
resource "aws_autoscaling_group" "gradle_asg" {
  name                = "${var.project_name}-asg"
  vpc_zone_identifier = var.public_subnets
  desired_capacity    = 2
  max_size            = 3
  min_size            = 2

  # This connects your instances to the Load Balancer
  target_group_arns   = var.target_group_arns 

  launch_template {
    id      = aws_launch_template.gradle_lt.id
    version = "$Latest"
  }

  # This makes sure you can identify your instances in the EC2 Dashboard
  tag {
    key                 = "Name"
    value               = "${var.project_name}-asg-instance"
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_policy" "cpu_scaling" {
  name                   = "cpu-scaling-policy"
  autoscaling_group_name = aws_autoscaling_group.gradle_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 40.0  # <--- Lower this to 20.0 or 30.0 for a faster test!
  }
}