resource "tencentcloud_as_scaling_config" "zy_test_tencentcloud_asg_config" {
  configuration_name = "zy_test_tencentcloud_asg_config"
  instance_types     = [var.tencentcloud_cvm_instance_type]

  cam_role_name = tencentcloud_cam_role.zy_test_cvm_role.name
  image_id      = var.tencentcloud_cvm_image_id

  system_disk_type = "CLOUD_BSSD"
  system_disk_size = "50"

  internet_charge_type       = "TRAFFIC_POSTPAID_BY_HOUR"
  internet_max_bandwidth_out = 10
  public_ip_assigned         = true

  enhanced_security_service         = false
  enhanced_monitor_service          = true
  enhanced_automation_tools_service = false

  instance_name_settings {
    instance_name = "zy-test-instance"
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

# Get instance's private ip from EC2 metadata service
echo "Fetching instance private ip..."
PRIVATEIP=$(curl http://metadata.tencentyun.com/latest/meta-data/local-ipv4)

# Fallback if metadata service is not reachable or private ip is not found
if [ -z "$PRIVATEIP" ]; then
  PRIVATEIP="CVM_PRIVATEIP_NOT_FOUND"
fi

# Create a custom index.html page
echo "Creating custom index.html with private ip..."
echo "<h1>Hello Zhou Yi from $PRIVATEIP</h1>" | sudo tee /var/www/html/index.html

# Ensure Nginx is started and enabled
echo "Starting and enabling Nginx service..."
sudo systemctl start nginx
sudo systemctl enable nginx

EOF
  )
}

resource "tencentcloud_as_scaling_group" "zy_test_tencentcloud_asg" {
  scaling_group_name = "zy_test_tencentcloud_asg"
  desired_capacity   = 3
  max_size           = 6
  min_size           = 2

  vpc_id = tencentcloud_vpc.zy_test_tencentcloud_vpc.id
  subnet_ids = [
    tencentcloud_subnet.zy_test_tencentcloud_subnet1.id,
    tencentcloud_subnet.zy_test_tencentcloud_subnet2.id,
  ]
  configuration_id = tencentcloud_as_scaling_config.zy_test_tencentcloud_asg_config.id

  tags = {
    Name = "zy_test_tencentcloud_asg"
  }

  health_check_type            = "CLB"
  lb_health_check_grace_period = 300

  multi_zone_subnet_policy = "EQUALITY"

  termination_policies = ["OLDEST_INSTANCE"]

  lifecycle {
    create_before_destroy = true
  }

  forward_balancer_ids {
    load_balancer_id = tencentcloud_clb_instance.zy_test_clb.id
    listener_id      = tencentcloud_clb_listener.zy_test_clb_listener.listener_id
    rule_id          = tencentcloud_clb_listener_rule.zy_test_clb_listener_rule.rule_id

    target_attribute {
      port   = 80
      weight = 100
    }
  }
}

resource "tencentcloud_as_scaling_policy" "zy_test_tencentcloud_asg_scale_out" {
  scaling_group_id    = tencentcloud_as_scaling_group.zy_test_tencentcloud_asg.id
  policy_name         = "zy_test_tencentcloud_asg_scale_out"
  adjustment_type     = "EXACT_CAPACITY"
  adjustment_value    = 3
  comparison_operator = "GREATER_THAN"
  metric_name         = "CPU_UTILIZATION"
  threshold           = 70
  period              = 300
  continuous_time     = 10
  statistic           = "AVERAGE"
  cooldown            = 360
}

# resource "tencentcloud_cvm_launch_template" "zy_test_tencentcloud_launch_template" {
#   launch_template_name = "zy_test_tencentcloud_launch_template"
#   instance_type        = var.tencentcloud_cvm_instance_type

#   cam_role_name = tencentcloud_cam_role.zy_test_cvm_role.name
#   image_id      = var.tencentcloud_cvm_image_id
#   placement {
#     zone = data.tencentcloud_availability_zones.available.name[0]
#   }

#   system_disk {
#     disk_size = 50
#     disk_type = "CLOUD_PREMIUM"
#   }

#   internet_accessible {
#     public_ip_assigned         = true
#     internet_charge_type       = "TRAFFIC_POSTPAID_BY_HOUR"
#     internet_max_bandwidth_out = 10
#   }

#   tag_specification {
#     resource_type = "instance"

#     tags {
#       key   = "Name"
#       value = "zy_test_tencentcloud_instance"
#     }
#   }

#   enhanced_service {
#     monitor_service {
#       enabled = true
#     }
#   }

#   tags = {
#     Name = "zy_test_tencentcloud_launch_template"
#   }

#   user_data = base64encode(<<EOF
# #!/bin/bash
# # Log all output to a file for debugging
# exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# # Update package information
# echo "Updating package information..."
# sudo apt-get update -y

# # Install Nginx
# echo "Installing Nginx..."
# sudo apt-get install -y nginx

# # Get instance's private ip from EC2 metadata service
# echo "Fetching instance private ip..."
# PRIVATEIP=$(curl http://metadata.tencentyun.com/latest/meta-data/local-ipv4)

# # Fallback if metadata service is not reachable or private ip is not found
# if [ -z "$PRIVATEIP" ]; then
#   PRIVATEIP="CVM_PRIVATEIP_NOT_FOUND"
# fi

# # Create a custom index.html page
# echo "Creating custom index.html with private ip..."
# echo "<h1>Hello Zhou Yi from $PRIVATEIP</h1>" | sudo tee /var/www/html/index.html

# # Ensure Nginx is started and enabled
# echo "Starting and enabling Nginx service..."
# sudo systemctl start nginx
# sudo systemctl enable nginx

# EOF
#   )
# }
