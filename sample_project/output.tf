output "security_group_id" {
  value = aws_security_group.lab_sg.id
}

output "ec2_instance_id" {
  value = aws_instance.lab_ans_master.id
}