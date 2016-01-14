#!/bin/bash

cd /data/src

if [[ ! -f "redis-2.2.7.tgz" ]];then
    wget -O redis-2.2.7.tgz http://pecl.php.net/get/redis-2.2.7.tgz
fi

tar -xzvf redis-2.2.7.tgz

cd redis-2.2.7

if [[ "$?" -ne 0 ]];then
    echo "Not found directory redis-2.2.7"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config

make && make install

grep "^extension_dir" /etc/php.ini  
if [[ "$?" -ne 0 ]];then
    #echo "extension_dir=/usr/local/php/lib/php/extensions/no-debug-zts-20151012" >> /etc/php.ini
fi

grep "redis.so" /etc/php.ini 
if [[ "$?" -ne 0 ]];then
    echo "extension=redis.so" >> /etc/php.ini
fi

