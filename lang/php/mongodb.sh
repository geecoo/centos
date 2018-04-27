#!/bin/zsh

mkdir -p /data/packages/src && cd /data/packages/src

if [[ ! -f "mongo-1.6.16.tgz" ]];then
    wget -O mongo-1.6.16.tgz http://pecl.php.net/get/mongo-1.6.16.tgz
fi

tar -xzvf mongo-1.6.16.tgz

cd mongo-1.6.16

if [[ "$?" -ne 0 ]];then
    echo "not found directory mongo-1.6.16"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config

make && make install

if [[ "$?" -eq 0 ]];then
    echo "extension=mongo.so" >> /etc/php.ini
fi
