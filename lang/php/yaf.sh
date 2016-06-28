#!/bin/zsh

mkdir -p /data/packages/src && cd /data/packages/src

if [[ ! -f "yaf-2.3.5.tgz" ]];then
    wget -O yaf-2.3.5.tgz http://pecl.php.net/get/yaf-2.3.5.tgz
fi

tar -xzvf yaf-2.3.5.tgz

cd yaf-2.3.5

if [[ "$?" -ne 0 ]];then
    echo "Not found directory yaf-2.3.5"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config

make && make install

if [[ "$?" -eq 0 ]];then
    echo "extension=yaf.so" >> /etc/php.ini
fi

cat<<EOF
add config to php.ini :
[yaf] 
yaf.use_namespace=1
yaf.environ=product 
yaf.use_spl_autoload=1 
yaf.name_suffix=0 
yaf.forward_limit=5 
EOF

