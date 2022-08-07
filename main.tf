#AWS Instance

#resource "aws_key_pair" "vikas-tf" {
 # key_name   = "vikas-tf"
  #public_key = file("${path.module}/dark22.pub") 
  


resource "aws_instance" "web" {
  ami = "ami-0cff7528ff583bf9a"
  instance_type = "t2.micro"
  #key_name = "${aws_key_pair.vikas-tf.key_name}"
  tags = {
    Name = "Vikas"
  }
}

# create keypair for bastion host
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion" {
  key_name   = "vikastf"     # Create "myKey" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh
}


resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {
     alarm_name               = "cpu-utilization"
     comparison_operator       = "GreaterThanOrEqualToThreshold"
     evaluation_periods       = "2"
     metric_name               = "CPUUtilization"
     namespace                 = "AWS/EC2"
     period                   = "120" #seconds
     statistic                 = "Average"
     threshold                 = "80"
   alarm_description         = "This metric monitors ec2 cpu utilization"
     insufficient_data_actions = []

dimensions = {

       InstanceId = "ami-0cff7528ff583bf9a"
    }
}



resource "aws_security_group" "error" {
  name        = "error"
  description = "Allow TLS inbound traffic"

dynamic "ingress" {
  for_each = [22,80,443,3306,27017]
  iterator = port
  content  {
    description = "Allow TLS inbound traffic"
    from_port = port.value
    to_port   = port.value
    protocol  = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }
}
}
  

