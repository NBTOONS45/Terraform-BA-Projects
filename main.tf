# LUIT Terraform Project BA #1


# Creating an EC2 Instance
resource "aws_instance" "BA_Linux_EC2" {
  instance_type = var.instance_type
  ami           = var.ami_id
  subnet_id     = var.subnet_id
  key_name      = var.ssh_key_name


  # Creating user data



  user_data = <<-EOF
#!/bin/bash
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
EOF
}

# Creating Ingress & Egress Security Groups

resource "aws_security_group" "BA_Jenkins_SG" {
  name        = "Jenkins Security Group"
  description = "Jenkins Security Group"
  vpc_id      = "vpc-008ad1a71fd6692bb"

  tags = {
    Name = "Jenkins SG"
  }
}

resource "aws_security_group_rule" "Allow_Port_22" {
  security_group_id = var.sg_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.jenkins_cidr_block
}

resource "aws_security_group_rule" "Allow_Port_8080" {
  security_group_id = var.sg_id
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = var.jenkins_cidr_block
}

resource "aws_security_group_rule" "Allow_All_Traffic" {
  security_group_id = var.sg_id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Creating a S3 Bucket Artifact for Jenkins

resource "aws_s3_bucket" "ba-jenkins-artifacts-bucket" {
  bucket = var.s3_bucket_name
  acl    = var.s3_bucket_acl
  tags = {
    Name        = "jenkins-artifacts-bucket"
    Environment = "Dev"
  }
}

#BA