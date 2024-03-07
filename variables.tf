# LUIT Terraform Project BA #1

# Variable AWS Region

variable "aws_region" {
  description = "This is the AWS Region."
  type        = string
  default     = "us-east-1"
}

# Creating a Variable  EC2 Instance
variable "instance_type" {
  description = "EC2 instance"
  type        = string
  default     = "t2.micro"
}

# Creating a Variable AMI

variable "ami_id" {
  description = "AMI ID of EC2"
  type        = string
  default     = "ami-07d9b9ddc6cd8dd30"
}

# Creating a Variable Ingress & Egress Security Groups

variable "subnet_id" {
  description = "Subnet ID of EC2"
  type        = string
  default     = "subnet-08d7962a011946932"
}

# Creating a Variable SSH Key

variable "ssh_key_name" {
  description = "Name of the Key Pair for the EC2"
  type        = string
  default     = "BA_KeyPair"
}

# Variable CIDR Block

variable "jenkins_cidr_block" {
  description = "CIDR block to connect to Jenkins"
  type        = list(string)
  default     = ["136.55.189.2/32"]
}

# Variable Security Group

variable "sg_id" {
  description = "Security Group for EC2"
  type        = string
  default     = "sg-005b368062d04188d"
}

# Variable S3 Bucket

variable "s3_bucket_name" {
 # LUIT Terraform Project BA #1

  description = "S3 Bucket name"
  type        = string
  default     = "ba-jenkins-artifacts-bucket"
}

# Variable ACL for S3 Bucket
variable "s3_bucket_acl" {
  description = "ACL access for S3 Bucket"
  type        = string
  default     = "private"
}

#BA