#Security Groups
resource "aws_security_group" "instances" {
  name = "instance-security-group"
  vpc_id      = aws_vpc.web_vpc.id  # Explicitly link to your VPC
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.instances.id
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  # Allow traffic ONLY from the ALB's security group
  source_security_group_id = aws_security_group.alb.id
}

# ALB Security Group 
resource "aws_security_group" "alb" {
  name        = "alb-security-group"
  description = "Allow HTTP/HTTPS traffic to ALB"
  vpc_id      = aws_vpc.web_vpc.id

  # Allow HTTP/HTTPS from the internet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to public internet
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to public internet
  }

  # Allow all outbound traffic
 egress {
    from_port   = 0    # Allow all ports (for dynamic target groups)
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

}
