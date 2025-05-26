resource "tencentcloud_cvm_launch_template" "zy_test_tencentcloud_launch_template" {
  launch_template_name        = "zy_test_tencentcloud_launch_template"
  instance_type = var.tencentcloud_cvm_instance_type

  cam_role_name = tencentcloud_cam_role.zy_test_cvm_role.name
  image_id      = var.tencentcloud_cvm_image_id
  placement {
    zone = data.tencentcloud_availability_zones.available.name[0]
  }

  system_disk {
    disk_size = 50
    disk_type = "CLOUD_PREMIUM"
  }

  internet_accessible {
    public_ip_assigned = true
    internet_charge_type = "TRAFFIC_POSTPAID_BY_HOUR"
    internet_max_bandwidth_out = 10
  }

  tag_specification {
    resource_type = "instance"

    tags {
        key  = "Name"
        value = "zy_test_tencentcloud_instance"
    }
  }

  enhanced_service {
    monitor_service {
      enabled = true
    }
  }

  tags = {
    Name = "zy_test_tencentcloud_launch_template"
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
