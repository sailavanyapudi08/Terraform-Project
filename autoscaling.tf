# Step 1: Create a Launch Template for EC2 instances
resource "aws_launch_template" "web_app_launch_template" {
  name_prefix   = "web-app-lt"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  # Use the existing security group
  vpc_security_group_ids = [aws_security_group.instances.id]

  # User data for all instances (adjust if needed)
user_data = base64encode(<<-EOF
  #!/bin/bash
  echo "Hello World!" > index.html
  python3 -m http.server 8080 --bind 0.0.0.0 &
EOF
)
  tags = {
    Name     = var.instance_name
    ExtraTag = local.extra_tag
  }
}

# Step 2: Create the Auto Scaling Group
resource "aws_autoscaling_group" "web_app_asg" {
 vpc_zone_identifier = [
  aws_subnet.private_subnet_az1.id,
  aws_subnet.private_subnet_az2.id
]
  name                = "web-app-asg"
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  health_check_type   = "EC2"

 # Attach to the existing ALB Target Group
  target_group_arns   = [aws_lb_target_group.instances.arn]

  launch_template {
    id      = aws_launch_template.web_app_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.instance_name
    propagate_at_launch = true
  }
}

# Step 3:Add Scaling Policies
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name
}
