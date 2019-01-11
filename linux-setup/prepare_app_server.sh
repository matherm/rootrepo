#!/bin/bash
echo "Type in private IP of target droplet:"
read private_ip

echo "Type in Hostname of target droplet:"
read remote_host

#Update hosts files
sudo sed -i "2i$private_ip $remote_host" /etc/hosts

#Remove Server from old known hosts
ssh-keygen -f "/home/ci/.ssh/known_hosts" -R $remote_host

#Copy files
ssh root@$remote_host 'mkdir /root/install'
scp ./install_app_server.sh root@$remote_host:/root/install/install_app_server.sh 
scp ./set_firewall.app.sh root@$remote_host:/root/install/set_firewall.app.sh 
scp ./sshd_config root@$remote_host:/root/install/sshd_config

#Start setup
ssh root@$remote_host 'chmod +x /root/install/install_app_server.sh'
ssh root@$remote_host '/root/install/install_app_server.sh'

#Update Known Hosts of Jenkins User
sudo cp /home/ci/.ssh/known_hosts /var/lib/jenkins/.ssh/known_hosts

#Impersonate access of jenkins User
sudo cp /home/ci/.ssh/id_rsa /var/lib/jenkins/.ssh/id_rsa
sudo chown jenkins /var/lib/jenkins/.ssh/id_rsa
sudo chgrp jenkins /var/lib/jenkins/.ssh/id_rsa



