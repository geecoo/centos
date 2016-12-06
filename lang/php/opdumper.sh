#!/bin/zsh
# 用于安装opdumper扩展， 编译文件opcode
# php -d opdumper.active=1 test.php 
# 不支持php 7

mkdir -p /data/packages/src && cd /data/packages/src

if [[ ! -d "opdumper" ]];then
    git clone https://github.com/ericzhang-cn/opdumper opdumper
fi

cd opdumper 

if [[ "$?" -ne 0 ]];then
    echo "Not found directory opdumper"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config

make && make install

if [[ "$?" -eq 0 ]];then
    echo "extension=opdumper.so" >> /etc/php.ini
fi
