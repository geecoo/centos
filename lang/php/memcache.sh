#!/bin/zsh

cd /data/packages/src

if [[ ! -f "memcache-3.0.8.tgz" ]];then
    wget -O memcache-3.0.8.tgz http://pecl.php.net/get/memcache-3.0.8.tgz
fi

tar -xzvf memcache-3.0.8.tgz

cd memcache-3.0.8

if [[ "$?" -ne 0 ]];then
    echo "Not found directory memcache-3.0.8"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config

make && make install

grep "^extension_dir" /etc/php.ini  
if [[ "$?" -ne 0 ]];then
    #echo "extension_dir=/usr/local/php/lib/php/extensions/no-debug-zts-20131226" >> /etc/php.ini
    echo "skip configure 'extension_dir'"
fi

grep "memcache.so" /etc/php.ini 
if [[ "$?" -ne 0 ]];then
    echo "extension=memcache.so" >> /etc/php.ini
fi

