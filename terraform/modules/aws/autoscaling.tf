resource "aws_launch_template" "zy_test_aws_launch_template" {
  name_prefix   = var.aws_resource_prefix
  instance_type = var.aws_instance_type

  iam_instance_profile {
    arn = aws_iam_instance_profile.zy_test_instance_profile.arn
  }
  image_id = var.aws_instance_ami_id

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
      volume_type = "gp3"
      encrypted   = true
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.zy_test_aws_sg.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "zy-test-instance"
    }
  }

  monitoring {
    enabled = true
  }


  user_data = base64encode(<<EOF
#!/bin/bash
# Log all output to a file for debugging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Update package information
echo "Updating package information..."
sudo apt-get update -y

# Install Nginx
echo "Installing Nginx..."
sudo apt-get install -y nginx

# Get instance's hostname from EC2 metadata service
echo "Fetching instance hostname..."
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` \
&& curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/
HOSTNAME=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-hostname)

# Fallback if metadata service is not reachable or hostname is not found
if [ -z "$HOSTNAME" ]; then
  HOSTNAME="EC2_HOSTNAME_NOT_FOUND"
fi

# Create a custom index.html page
echo "Creating custom index.html with hostname..."
echo "<h1>Hello Zhou Yi from $HOSTNAME</h1>" | sudo tee /var/www/html/index.html

# Ensure Nginx is started and enabled
echo "Starting and enabling Nginx service..."
sudo systemctl start nginx
sudo systemctl enable nginx

EOF
  )
}

resource "aws_autoscaling_group" "zy_test_aws_asg" {
  name_prefix         = var.aws_resource_prefix
  desired_capacity    = 3
  max_size            = 6
  min_size            = 2
  vpc_zone_identifier = [aws_subnet.zy_test_aws_subnet1.id, aws_subnet.zy_test_aws_subnet2.id]
  launch_template {
    id      = aws_launch_template.zy_test_aws_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "zy-test-asg-instance"
    propagate_at_launch = true
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300

  availability_zone_distribution {
    capacity_distribution_strategy = "balanced-best-effort"
  }

  termination_policies = ["OldestInstance"]

  lifecycle {
    create_before_destroy = true
  }

  target_group_arns = [aws_lb_target_group.zy_test_aws_tg.arn]
}

resource "aws_autoscaling_policy" "zy_test_aws_asg_scale_out" {
  name                   = "${var.aws_resource_prefix}-scale-out"
  scaling_adjustment     = 3
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.zy_test_aws_asg.name
}

resource "aws_cloudwatch_metric_alarm" "zy_test_aws_asg_high_cpu" {
  alarm_name          = "${var.aws_resource_prefix}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 70
  alarm_actions       = [aws_autoscaling_policy.zy_test_aws_asg_scale_out.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.zy_test_aws_asg.name
  }
}
