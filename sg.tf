# Security Group

resource "aws_security_group" "ba-sg" {
  name        = "ba-security-group"
  description = "Allow  inbound traffic and all outbound traffic"
  vpc_id      = "vpc-05c4f27c6e9976755"

  tags = {
    Name = "ba-sg"
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
}
