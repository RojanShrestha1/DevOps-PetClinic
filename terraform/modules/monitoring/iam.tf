# 1. The Role: Defines WHO can use these permissions (EC2 Service)
resource "aws_iam_role" "monitoring_role" {
  name = "${var.project_name}-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# 2. The Policy Attachment: Gives "Read Only" access to EC2 data
resource "aws_iam_role_policy_attachment" "ec2_read_only" {
  role       = aws_iam_role.monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

# 3. The Instance Profile: The "Container" that passes the role to the EC2
resource "aws_iam_instance_profile" "monitoring_profile" {
  name = "${var.project_name}-monitoring-profile"
  role = aws_iam_role.monitoring_role.name
}