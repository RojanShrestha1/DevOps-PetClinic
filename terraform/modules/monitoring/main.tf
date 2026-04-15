# 1. The Bucket (Service-Dependent)
resource "aws_s3_bucket" "ansible_config_bucket" {
  bucket = "${var.project_name}-monitoring-configs-2026" # Unique name
}

# 2. Privacy Settings
resource "aws_s3_bucket_public_access_block" "ansible_config_privacy" {
  bucket = aws_s3_bucket.ansible_config_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 3. The Zip Upload
resource "aws_s3_object" "ansible_zip" {
  bucket = aws_s3_bucket.ansible_config_bucket.id
  key    = "monitoring-setup.zip"
  # Use path.module to tell Terraform to look inside the monitoring module folders
  source = "modules/monitoring/monitoring-setup.zip"
  etag   = filemd5("modules/monitoring/monitoring-setup.zip")
}

# 4. The EC2 Instance
resource "aws_instance" "monitoring_server" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.monitoring_sg_id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.monitoring_profile.name

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io ansible unzip awscli
              systemctl start docker

              # 1. Install the collection AND the python library (The fix for your fatal error)
              ansible-galaxy collection install community.docker
              apt-get install -y python3-docker

              mkdir -p /opt/monitoring
              mkdir -p /etc/prometheus # Ensure this exists for the mount
              cd /opt/monitoring

              # Fetch the setup
              aws s3 cp s3://${aws_s3_bucket.ansible_config_bucket.id}/monitoring-setup.zip .
              unzip -o monitoring-setup.zip # -o to overwrite if re-running

              # 2. Manual step: Copy prometheus.yml to /etc (The fix for the volume mount)
              # This ensures the file is exactly where the Docker command expects it
              cp /opt/monitoring/prometheus.yml /etc/prometheus/prometheus.yml
              chmod 644 /etc/prometheus/prometheus.yml

              # 3. Run the playbook
              cd ansible
              ansible-playbook deploy_monitoring.yml
              EOF

  # Ensure the zip is in S3 before the server starts
  depends_on = [aws_s3_object.ansible_zip]

    tags = {
        Name = "${var.project_name}-monitoring-server"
    }
}