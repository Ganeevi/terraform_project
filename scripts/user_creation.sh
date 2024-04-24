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