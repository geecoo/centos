#!/bin/bash

if [[ -z "$TAR_SRC_DIR" ]];then
    TAR_SRC_DIR="/data/packages/src"
    mkdir -p $TAR_SRC_DIR
fi

basepath=$(cd `dirname $0`; pwd)

cd $TAR_SRC_DIR

if [ ! -f "nginx-1.11.8.tar.gz" ];then 
    wget --no-check-certificate -O  nginx-1.11.8.tar.gz http://nginx.org/download/nginx-1.11.8.tar.gz 
fi

tar -xzvf nginx-1.11.8.tar.gz && cd nginx-1.11.8

if [[ "$?" -ne 0 ]];then
    echo "not found directory nginx-1.11.8"
    exit 1
fi


groupadd www
useradd -g www -s /bin/false -M www

./configure \
    --user=www \
    --group=www \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --prefix=/usr/local/nginx \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/lock/nginx.lock \
    --with-http_ssl_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_realip_module \
    --with-http_gzip_static_module \
    --with-http_stub_status_module \
    --with-mail \
    --with-mail_ssl_module \
    --http-client-body-temp-path=/var/tmp/nginx/client \
    --http-proxy-temp-path=/var/tmp/nginx/proxy \
    --http-fastcgi-temp-path=/var/tmp/nginx/fastcgi \
    --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi \
    --http-scgi-temp-path=/var/tmp/nginx/scgi

#--with-pcre=../pcre-8.37 \
#--with-zlib=../zlib-1.2.8 \
#--with-debug \
make && make install

if [[ "$?" -ne 0 ]];then
    echo -en "\033[0;30;41m nginx install failure  ...no \033[0;37m \n"
    exit 1
else
    echo -en "\033[0;30;42m nginx install success ...ok \033[0;37m \n"
fi


echo "export PATH=/usr/local/nginx/sbin:\$PATH" > /etc/profile.d/nginx.sh
    
.  /etc/profile.d/nginx.sh

# init.d script
if [ -f "$basepath/script.sh" ];then
    cp $basepath/script.sh /etc/init.d/nginx
    chmod +x /etc/init.d/nginx
fi

cat<<EOF
    Usage:
    cp web/nginx/script.sh /etc/init.d/nginx
    chmod +x /etc/init.d/nginx
    /etc/init.d/nginx -h
EOF

