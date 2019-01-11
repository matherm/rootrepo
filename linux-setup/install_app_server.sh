#!/bin/bash
# execute install_app_server.sh

echo "Type in user name"
read username

echo "Type in password"
read password

#add user
echo "add user"
adduser "$username" <<EOF
$password
$password
EOF
usermod -aG sudo $username

#update apt-get
echo "update apt-get"
apt-get update 

#add authorized key for ssh connect
echo "add authorized key for ssh connect"
runuser -l  $username -c "mkdir /home/$username/.ssh"
runuser -l  $username -c "chmod 700 /home/$username/.ssh"
cp /root/.ssh/authorized_keys /home/$username/.ssh/authorized_keys
chown $username /home/$username/.ssh/authorized_keys
chgrp $username /home/$username/.ssh/authorized_keys
runuser -l  $username -c "chmod 600 /home/$username/.ssh/authorized_keys"

#Set firewall
chmod +x /root/install/set_firewall.app.sh
sh /root/install/set_firewall.app.sh

#restrict root login
echo "restrict root login"
cp /root/install/sshd_config /etc/ssh/sshd_config 
systemctl reload sshd

#install htop
echo "install htop"
apt-get install htop -y

#install nodejs
echo "install nodejs"
apt-get install nodejs -y
ln -s /usr/bin/nodejs /usr/bin/node

#install npm
echo "install npm"
apt-get install npm -y

#install pm2
echo "install pm2"
npm install pm2 -g