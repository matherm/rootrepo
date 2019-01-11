#!/bin/bash

# Add to NGINX config
# load_module modules/ngx_http_auth_digest_module.so;

NGINX_VER="1.10.1"
service nginx stop
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#cleanup
rm -r /opt/nginx
mkdir /opt/nginx
cd /opt/nginx

#Dependencies
add-apt-repository -s ppa:nginx/stable

apt-get update
apt-get install openssl libssl-dev libpcre3-dev libpcre++-dev dpkg-dev

#backup
cp /etc/nginx/nginx.conf /tmp/nginx.conf.backup
mv /etc/init/nginx.conf /tmp/nginx.init.conf.backup
cp /etc/nginx/sites-enabled/* /tmp/
cp /etc/nginx/.htpasswd /tmp/.htpasswd

#upgrade NGINX
apt-get install --only-upgrade nginx
service nginx stop

#Get NGINX
#wget http://nginx.org/download/nginx-$NGINX_VER.tar.gz
#tar zxvf nginx-$NGINX_VER.tar.gz
#rm nginx-$NGINX_VER.tar.gz
apt-get source nginx
apt-get build-dep nginx

#Get HTTP-DIGEST
git clone https://github.com/atomx/nginx-http-auth-digest.git
cd nginx-http-auth-digest
git pull

#configure NGINX
cd ../nginx-$NGINX_VER
cp $DIR/patched_make_file ./debian/rules 
dpkg-buildpackage -b

#install
cd ..
FILE=$(ls | grep nginx-full_${NGINX_VER}*.deb )
dpkg --install $FILE

#restart
service nginx start








