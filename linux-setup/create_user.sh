adduser $1
mkdir /home/$1/.ssh
echo " " > /home/$1/.ssh/authorized_keys
chmod 700 /home/$1/.ssh
chmod 600 /home/$1/.ssh/authorized_keys
cp /home/ios/.bashrc /home/$1/.bashrc
chown -R $1:$1 /home/$1

cp -iR /home/$1 /home_ext
chown -R $1:$1 /home_ext/$1
rm -rf /home/$1
ln -s /home_ext/$1 /home/$1
chown -h $1:$1 /home/$1
usermod -aG sudo $1

