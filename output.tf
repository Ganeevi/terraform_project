/*output "jenkins-master" {
    value = [ aws_instance.jenkins-master.public_ip, aws_instance.jenkins-master.private_ip ]
}

output "jenkins-slave" {
    value = [ aws_instance.jenkins-slave.public_ip, aws_instance.jenkins-slave.private_ip ]
}

output "Nexus-Server" {
    value = [aws_instance.Nexus-Server.public_ip, aws_instance.Nexus-Server.private_ip]
}

output "Sonar-Server" {
    value = [aws_instance.Sonar-Server.public_ip, aws_instance.Sonar-Server.private_ip]
  
}

output "ansible-CM" {
  value = [aws_instance.ansible-CM.public_ip, aws_instance.ansible-CM.private_ip]
}

output "ansible-node" {
  value = [aws_instance.ansible-node.*.public_ip, aws_instance.ansible-node.*.private_ip]
}*/