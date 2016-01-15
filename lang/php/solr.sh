#!/bin/zsh

cd /data/src

if [[ ! -f "solr-2.3.0.tgz" ]];then
    wget -O solr-2.3.0.tgz http://pecl.php.net/get/solr-2.3.0.tgz
fi

tar -xzvf solr-2.3.0.tgz

cd solr-2.3.0

if [[ "$?" -ne 0 ]];then
    echo "Not found directory solr-2.3.0"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config

make && make install

if [[ "$?" -ne 0 ]];then
    echo "install failed"
    exit 1
fi

grep "solr.so" /etc/php.ini 
if [[ "$?" -ne 0 ]];then
    echo "extension=solr.so" >> /etc/php.ini
fi

