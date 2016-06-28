#!/bin/bash

cd /data/packages/src

if [[ ! -f "redis-2.2.8.tgz" ]];then
    wget -O redis-2.2.8.tgz http://pecl.php.net/get/redis-2.2.8.tgz
fi

tar -xzvf redis-2.2.8.tgz

cd redis-2.2.8

if [[ "$?" -ne 0 ]];then
    echo "Not found directory redis-2.2.8"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config

make && make install

if [[ "$?" -eq 0 ]];then
    echo "extension=redis.so" >> /etc/php.ini
fi

