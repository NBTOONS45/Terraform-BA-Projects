# Launch template

resource "aws_launch_template" "ba-asg-launch-template" {
  name_prefix   = "ba-asg-ec2"
  image_id      = "ami-07d9b9ddc6cd8dd30"
  instance_type = "t2.micro"
  key_name      = "BA_KeyPair"

  vpc_security_group_ids = [aws_security_group.ba-sg.id] # Associate security group to instances

  # Apache user data 
  user_data = base64encode(<<EOF
            #!/bin/bash
            sudo apt-get update -y
            sudo apt install -y apache2
            systemctl start apache2
            systemctl enable apache2
            EOF
  )
}

# auto-scaling-group

resource "aws_autoscaling_group" "ba-asg" {
  name                = "ba-autoscaling-group"
  vpc_zone_identifier = ["subnet-0ce7cc7c5e0dd2f3f", "subnet-05c016e9f032e0f14"]
  min_size            = 2
  max_size            = 5
  desired_capacity    = 2

  launch_template {
    id      = aws_launch_template.ba-asg-launch-template.id
    version = "$Latest"
  }


}


# Security Group

resource "aws_security_group" "ba-sg" {
  name        = "ba-security-group"
  description = "Allow  inbound traffic and all outbound traffic"
  vpc_id      = "vpc-05c4f27c6e9976755"

  tags = {
    Name = "ba-sg"
  }
}

#Ingress Port 443 HTTPS
resource "aws_security_group_rule" "ba-allow_inbound_443" {
  security_group_id = aws_security_group.ba-sg.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Ingress Port 80 HTTP
resource "aws_security_group_rule" "ba-allowiInbound_80" {
  security_group_id = aws_security_group.ba-sg.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Ingress SSH
resource "aws_security_group_rule" "ba-allow_inbound_SSH" {
  security_group_id = aws_security_group.ba-sg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

#Egress Allow 

resource "aws_security_group_rule" "ba-allow_outbound" {
  security_group_id = aws_security_group.ba-sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]

}

#s3 bucket backend

resource "aws_s3_bucket" "ba-s3-backend" {
  bucket = "ba-s3-backend"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "ba_s3-backend"
    Environment = "Dev"
  }
}



# dynamodb table for backend

resource "aws_dynamodb_table" "ba-statelock" {
  name         = "state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}



