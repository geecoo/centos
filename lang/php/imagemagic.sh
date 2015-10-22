#!/bin/zsh

cd /data/src

# first install imageMagick server

if [[ ! -f "ImageMagick.tar.gz" ]];then
    wget -O ImageMagick.tar.gz http://www.imagemagick.org/download/ImageMagick.tar.gz
fi

tar -xzvf ImageMagick.tar.gz

cd ImageMagick-6.9.2-4

if [[ "$?" -ne 0 ]];then
    echo "Not found directory ImageMagick-6.9.2-0"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --prefix=/usr/local/imagemagick

make && make install

if [[ "$?" -ne 0 ]];then
    echo "install imagemagick failure ...no"
    exit 1
fi

cd /data/src

if [[ ! -f "imagick-3.1.2.tgz" ]];then
    wget -O imagick-3.1.2.tgz http://pecl.php.net/get/imagick-3.1.2.tgz
fi

tar -xzvf imagick-3.1.2.tgz

cd imagick-3.1.2

if [[ "$?" -ne 0 ]];then
    echo "Not found directory imagick-3.1.2"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config --with-imagick=/usr/local/imagemagick

make && make install

grep "^extension_dir" /etc/php.ini  
if [[ "$?" -ne 0 ]];then
    echo "extension_dir=/usr/local/php/lib/php/extensions/no-debug-zts-20131226" >> /etc/php.ini
fi

grep "imagick.so" /etc/php.ini 
if [[ "$?" -ne 0 ]];then
    echo "extension=imagick.so" >> /etc/php.ini
fi

