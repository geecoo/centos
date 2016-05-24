#!/bin/zsh

cd /data/src

if [[ ! -f "yaf-3.0.2.tgz" ]];then
    wget -O yaf-3.0.2.tgz http://pecl.php.net/get/yaf-3.0.2.tgz
fi

tar -xzvf yaf-3.0.2.tgz

cd yaf-3.0.2

if [[ "$?" -ne 0 ]];then
    echo "Not found directory yaf-3.0.2"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config

make && make install

grep "yaf.so" /etc/php.ini 
if [[ "$?" -ne 0 ]];then
    echo "extension=yaf.so" >> /etc/php.ini
fi

cat<<EOF
Maybe config :
[yaf] 
yaf.use_namespace = 0 
yaf.environ = product 
yaf.use_spl_autoload = 1 
;yaf.name_suffix        = 0 
yaf.forward_limit = 5 
EOF

