#!/bin/zsh

mkdir -p /data/packages/src && cd /data/packages/src

if [[ ! -f "swoole-1.8.5-stable.tar.gz" ]];then
    wget -O swoole-1.8.5-stable.tar.gz https://github.com/swoole/swoole-src/archive/swoole-1.8.5-stable.tar.gz
fi

tar -xzvf swoole-1.8.5-stable.tar.gz

cd swoole-src-swoole-1.8.5-stable

if [[ "$?" -ne 0 ]];then
    echo "Not found directory swoole-src-swoole-1.8.5-stable"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config

make && make install

if [[ "$?" -eq 0 ]];then
    echo "extension=swoole.so" >> /etc/php.ini
    echo "Install success"
fi

