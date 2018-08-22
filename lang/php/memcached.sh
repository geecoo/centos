#!/bin/zsh

# depend on libmemcached
yum install -y  libmemcached libmemcached-devel

# php extension memcached  via libmemcached library

cd /data/packages/src

yum info libmemcached

if [[ "$?" -ne 0 ]];then
    yum install -y libmemcached libmemcached-devel
fi

if [[ ! -f "memcached-3.0.4.tgz" ]];then
    wget -O memcached-3.0.4.tgz http://pecl.php.net/get/memcached-3.0.4.tgz
fi

tar -xzvf memcached-3.0.4.tgz

cd memcached-3.0.4

if [[ "$?" -ne 0 ]];then
    echo "not found directory memcached-3.0.4"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config

make && make install

if [[ "$?" -ne 0 ]];then
    echo "memcached install failed"
    exit 1
fi

if [[ "$?" -eq 0 ]];then
    echo "extension=memcached.so" >> /etc/php.ini
fi
