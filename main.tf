# LUIT Terraform Project BA #1
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Creating an EC2 Instance
resource "aws_instance" "BA_Linux_EC2" {
  instance_type = "t2.micro"
  ami           = "ami-07d9b9ddc6cd8dd30"
  subnet_id     = "subnet-08d7962a011946932"
  key_name      = "BA_KeyPair"
  
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
  security_group_id = "sg-005b368062d04188d"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["136.55.189.2/32"]
}

resource "aws_security_group_rule" "Allow_Port_8080" {
  security_group_id = "sg-005b368062d04188d"
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["136.55.189.2/32"]
}

resource "aws_security_group_rule" "Allow_All_Traffic" {
  security_group_id = "sg-005b368062d04188d"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Creating a S3 Bucket Artifact for Jenkins

resource "aws_s3_bucket" "ba_jenkins_artifacts_bucket" {
  bucket = "ba-jenkins-artifacts-bucket"
  acl    = "private"
  tags = {
    Name        = "jenkins-artifacts-bucket"
    Environment = "Dev"
  }
}

#BA