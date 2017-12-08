#!/bin/zsh

mkdir -p /data/packages/src && cd /data/packages/src

if [[ ! -f "gearman.zip" ]];then
    wget -O gearman.zip https://github.com/wcgallego/pecl-gearman/archive/master.zip
fi

unzip gearman.zip

cd pecl-gearman-master

if [[ "$?" -ne 0 ]];then
    echo "not found directory pecl-gearman-master"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config

make && make install

if [[ "$?" -eq 0 ]];then
    echo "extension=gearman.so" >> /etc/php.ini
fi
