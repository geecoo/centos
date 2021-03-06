#!/bin/zsh

cd /data/packages/src


yum install -y libevent libevent-devel

if [[ ! -f "memcached-1.5.9.tar.gz" ]];then
    wget -O memcached-1.5.9.tar.gz http://memcached.org/files/memcached-1.5.9.tar.gz
fi

tar -xzvf memcached-1.5.9.tar.gz

cd memcached-1.5.9

if [[ "$?" -ne 0 ]];then
    echo "Not found directory memcached-1.5.9"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --prefix=/usr/local/memcached/ --with-libevent=/usr

make && make install

