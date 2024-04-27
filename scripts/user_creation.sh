#!/bin/bash

# Define username
usernames="ansible"

for username in "${usernames[@]}"
do
sudo useradd -m -s /bin/bash "$username"
echo "$username:ansible" | sudo chpasswd
sudo chown -R "$username:$username" "/home/$username"
sudo chmod 700 "/home/$username"
sudo usermod -aG wheel "$username"
done
#fi

echo "Users are created successfully"
sudo cat /etc/passwd | grep -i ansible


sleep 5

echo "Ansible user permissions"
sudo sed -i 's\#PasswordAuthentication yes\PasswordAuthentication yes\g' /etc/ssh/sshd_config
sudo sed -i 's\PasswordAuthentication no\#PasswordAuthentication no\g' /etc/ssh/sshd_config
sudo systemctl restart sshd

sudo mkdir -p /home/ansible/.ssh
sudo mv id_rsa id_rsa.pub /home/ansible/.ssh
sudo chown ansible:ansible -R /home/ansible/.ssh/
sudo chmod 0600 /home/ansible/.ssh/id_rsa
sudo chmod 0644 /home/ansible/.ssh/id_rsa.pub