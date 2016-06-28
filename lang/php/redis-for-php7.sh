#!/bin/bash

cd /data/packages/src

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

if [[ "$?" -eq 0 ]];then
    echo "extension=redis.so" >> /etc/php.ini
fi

