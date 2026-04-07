# 1. The Monitoring EC2 Instance
resource "aws_instance" "monitoring_server" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.monitoring_sg_id]
  key_name               = var.key_name

  # IAM Instance Profile is CRITICAL so Prometheus can "see" your other EC2s
  iam_instance_profile = aws_iam_instance_profile.monitoring_profile.name

  user_data = <<-EOF
              #!/bin/bash
              # Update and install Docker
              apt-get update -y
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker

              # Create a directory for Prometheus configuration
              mkdir -p /etc/prometheus

              # Create the prometheus.yml file
              # This tells Prometheus to find any EC2 with the 'App' tag
              cat << 'PCONFIG' > /etc/prometheus/prometheus.yml
              global:
                scrape_interval: 15s

              scrape_configs:
                - job_name: 'ec2-nodes'
                  ec2_sd_configs:
                    - region: 'ap-south-1' 
                      port: 9100
                  relabel_configs:
                    - source_labels: [__meta_ec2_tag_Name]
                      regex: '.*-asg-instance'
                      action: keep
              PCONFIG

              # Start Prometheus (The Database)
              docker run -d \
                --name prometheus \
                -p 9090:9090 \
                -v /etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
                prom/prometheus --config.file=/etc/prometheus/prometheus.yml

              # Start Grafana (The UI)
              # Default login: admin / admin
              docker run -d \
                --name grafana \
                -p 3000:3000 \
                grafana/grafana
              EOF

  tags = {
    Name = "${var.project_name}-monitoring-server"
  }
}