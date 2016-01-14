#!/bin/zsh

# php extension memcached  via libmemcached library

cd /data/src

yum info libmemcached

if [[ "$?" -ne 0 ]];then
    yum install -y libmemcached libmemcached-devel
fi

if [[ ! -d "php-memcached" ]];then
    git clone https://github.com/php-memcached-dev/php-memcached
    #git clone https://github.com/php-memcached-dev/php-memcached.git
fi

cd php-memcached 
git checkout -b php7 origin/php7

if [[ "$?" -ne 0 ]];then
    echo "Not found directory php-memcached"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config

make && make install

grep "memcached.so" /etc/php.ini
if [[ "$?" -ne 0 ]];then
    echo "extension=memcached.so" >> /etc/php.ini
fi
