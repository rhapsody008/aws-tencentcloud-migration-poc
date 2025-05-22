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
            encrypted = true
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

# Create a custom index.html page
echo "Creating custom index.html..."
echo "<h1>Hello Zhou Yi!</h1>" | sudo tee /var/www/html/index.html

# Ensure Nginx is started and enabled
echo "Starting and enabling Nginx service..."
sudo systemctl start nginx
sudo systemctl enable nginx

EOF
  )
}

resource "aws_autoscaling_group" "zy_test_aws_asg" {
    name_prefix          = var.aws_resource_prefix
    desired_capacity     = 3
    max_size             = 6
    min_size             = 2
    vpc_zone_identifier  = [aws_subnet.zy_test_aws_subnet]
    launch_template {
        id      = aws_launch_template.zy_test_aws_launch_template.id
        version = "$Latest"
    }

    tag {
        key                 = "Name"
        value               = "zy-test-asg-instance"
        propagate_at_launch = true
    }

    health_check_type = "EC2"
    health_check_grace_period = 300

    termination_policies = ["OldestInstance"]

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_security_group" "zy_test_aws_sg" {
    name_prefix = var.aws_resource_prefix
    description = "Security group for EC2 instances"
    vpc_id      = aws_vpc.zy_test_aws_vpc.id

    ingress {
        description = "Allow SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}