#!/bin/zsh
# 用于安装vld扩展， 编译文件opcode
# another extension xdebug
# php -d vld.active=1 test.php

mkdir -p /data/packages/src && cd /data/packages/src

if [[ ! -d "vld" ]];then
    git clone https://github.com/derickr/vld.git vld
fi

cd vld 

if [[ "$?" -ne 0 ]];then
    echo "Not found directory vld"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config --enable-vld

make && make install

if [[ "$?" -eq 0 ]];then
    echo "extension=vld.so" >> /etc/php.ini
fi
