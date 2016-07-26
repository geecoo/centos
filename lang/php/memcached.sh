#!/bin/zsh

# depend on libmemcached
yum install -y  libmemcached libmemcached-devel

# php extension memcached  via libmemcached library

cd /data/packages/src

yum info libmemcached

if [[ "$?" -ne 0 ]];then
    yum install -y libmemcached libmemcached-devel
fi

if [[ ! -f "memcached-2.2.0.tgz" ]];then
    wget -O memcached-2.2.0.tgz http://pecl.php.net/get/memcached-2.2.0.tgz
fi

tar -xzvf memcached-2.2.0.tgz

cd memcached-2.2.0

if [[ "$?" -ne 0 ]];then
    echo "Not found directory memcached-2.2.0"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config

make && make install

