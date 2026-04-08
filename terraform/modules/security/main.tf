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
    description = "Only allow traffic from the ALB"
    from_port   = 8080 # Your App Port
    to_port     = 8080
    protocol    = "tcp"
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




# 3. Monitoring Ec2 Security Group (The Watchtower)
# 1. The "Doctor's Station" Security Group
resource "aws_security_group" "monitoring_sg" {
  name        = "${var.project_name}-monitoring-sg"
  description = "Allow Prometheus and Grafana traffic"
  vpc_id      = var.vpc_id

  # Access Grafana Dashboard from your Mac
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Access Prometheus UI from your Mac (Optional but helpful)
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH if you need to debug the monitoring server
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow the server to download Docker images from the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. The "Stethoscope" Rule (Cross-Communication)
# This tells the APP servers: "It is okay to let the MONITORING server talk to you on 9100"
resource "aws_security_group_rule" "allow_monitoring_scrape" {
  type                     = "ingress"
  from_port                = 9100
  to_port                  = 9100
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_sg.id        # Your App Server SG
  source_security_group_id = aws_security_group.monitoring_sg.id # The Monitoring SG
}


resource "aws_security_group_rule" "allow_prometheus_to_app" {
  type                     = "ingress"
  from_port               = 8080
  to_port                 = 8080
  protocol                = "tcp"
  security_group_id       = aws_security_group.ec2_sg.id # Your App SG
  source_security_group_id = aws_security_group.monitoring_sg.id # Your Monitoring SG
}