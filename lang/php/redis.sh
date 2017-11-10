#!/bin/bash

cd /data/packages/src

if [[ ! -f "redis-3.1.4.tgz" ]];then
    wget -O redis-3.1.4.tgz http://pecl.php.net/get/redis-3.1.4.tgz
fi

tar -xzvf redis-3.1.4.tgz

cd redis-3.1.4

if [[ "$?" -ne 0 ]];then
    echo "Not found directory redis-3.1.4"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config

make && make install

if [[ "$?" -eq 0 ]];then
    echo "extension=redis.so" >> /etc/php.ini
fi

