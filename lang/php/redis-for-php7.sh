#!/bin/bash

cd /data/src

if [[ ! -d phpredis ]];then
    git clone https://github.com/edtechd/phpredis.git
fi

cd phpredis 

if [[ "$?" -ne 0 ]];then
    echo "Not found directory phpredis"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config

make && make install

grep "^extension_dir" /etc/php.ini  

if [[ "$?" -ne 0 ]];then
    # echo "extension_dir=/usr/local/php/lib/php/extensions/no-debug-zts-20151012" >> /etc/php.ini
    echo "Not found configure 'extension_dir'"
fi

grep "redis.so" /etc/php.ini 
if [[ "$?" -ne 0 ]];then
    echo "extension=redis.so" >> /etc/php.ini
fi

