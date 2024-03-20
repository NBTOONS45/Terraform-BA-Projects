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