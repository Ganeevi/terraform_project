output "public_ip" {
    value = [ aws_instance.jenkins-master.public_ip, aws_instance.jenkins-slave.public_ip ]
}

output "private_ip" {
    value = [ aws_instance.jenkins-master.private_ip, aws_instance.jenkins-slave.private_ip ]
}