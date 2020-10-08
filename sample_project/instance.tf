resource "aws_security_group" "lab_sg" {
  name        = var.AWS_SG
  description = "Allow HTTP, HTTPS and SSH traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mymaangolab_sg"
  }
}


resource "aws_instance" "lab_ans_master" {
  key_name      = var.AWS_KEY_NAME
  ami           = var.AWS_AMI 
  instance_type = var.AWS_INSTANCE_TYPE

  tags = {
    Name = "Ans_Master"
  }

  vpc_security_group_ids = [
    aws_security_group.lab_sg.id
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/Users/mango/Downloads/mymangolab.pem")
    host        = aws_instance.lab_ans_master.public_ip
  }

  provisioner "file" {
  source      = "./files/mymangolab.sh"
  destination = "/tmp/mymangolab.sh"
  }

  provisioner "remote-exec" {
  inline = [
      "sudo chmod +x /tmp/mymangolab.sh",
      "sudo /tmp/mymangolab.sh",
      "sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y",
      "sudo yum install ansible -y"
    ]
  }


}