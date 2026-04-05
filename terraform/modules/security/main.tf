# 1. ALB Security Group (The Front Door)
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # The World
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    
  }
}

# 2. EC2 Security Group (The Private Entrance)
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-ec2-sg"
  description = "Allow traffic ONLY from the ALB"
  vpc_id      = var.vpc_id

ingress {
    description     = "Only allow traffic from the ALB"
    from_port       = 8080                         # Your App Port
    to_port         = 8080
    protocol        = "tcp"
    # SECURITY WIN: No CIDR blocks here! 
    # Only the ALB's ID is allowed.
    security_groups = [aws_security_group.alb_sg.id] 
  }

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For better security, use "your_ip/32"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}