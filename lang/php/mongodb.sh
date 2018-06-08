#!/bin/zsh

mkdir -p /data/packages/src && cd /data/packages/src

if [[ ! -f "mongodb-1.4.4.tgz" ]];then
    wget -O mongodb-1.4.4.tgz http://pecl.php.net/get/mongodb-1.4.4.tgz
fi

tar -xzvf mongodb-1.4.4.tgz

cd mongodb-1.4.4

if [[ "$?" -ne 0 ]];then
    echo "not found directory mongodb-1.4.4"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config

make && make install

if [[ "$?" -eq 0 ]];then
    echo "extension=mongodb.so" >> /etc/php.ini
fi
