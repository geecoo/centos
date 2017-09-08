#!/bin/zsh

mkdir -p /data/packages/src && cd /data/packages/src

if [[ ! -f "swoole-1.9.18.tgz" ]];then
    #wget -O swoole-1.8.7-stable.tar.gz https://github.com/swoole/swoole-src/archive/swoole-1.8.7-stable.tar.gz
    wget -O swoole-1.9.18.tgz http://pecl.php.net/get/swoole-1.9.18.tgz
fi

tar -xzvf swoole-1.9.18.tgz

cd swoole-1.9.18

if [[ "$?" -ne 0 ]];then
    echo "Not found directory swoole-1.9.18"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config

make && make install

if [[ "$?" -eq 0 ]];then
    echo "extension=swoole.so" >> /etc/php.ini
    echo "Install success"
fi

