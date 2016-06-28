#!/bin/zsh

cd /data/packages/src

# first install imageMagick server
# yum install -y ImageMagick ImageMagick-devel

if [[ ! -f "ImageMagick.tar.gz" ]];then
    wget -O ImageMagick.tar.gz http://www.imagemagick.org/download/ImageMagick.tar.gz
fi

tar -xzvf ImageMagick.tar.gz

cd ImageMagick-6.9.3-0

if [[ "$?" -ne 0 ]];then
    echo "Not found directory ImageMagick-6.9.3-0"
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

if [[ ! -f "imagick-3.4.0RC5.tgz" ]];then
    wget -O imagick-3.4.0RC5.tgz http://pecl.php.net/get/imagick-3.4.0RC5.tgz
fi

tar -xzvf imagick-3.4.0RC5.tgz

cd imagick-3.4.0RC5

if [[ "$?" -ne 0 ]];then
    echo "Not found directory imagick-3.4.0RC5"
    exit 1
fi

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config --with-imagick=/usr/local/imagemagick

make && make install

grep "^extension_dir" /etc/php.ini  

grep "imagick.so" /etc/php.ini 
if [[ "$?" -ne 0 ]];then
    echo "extension=imagick.so" >> /etc/php.ini
fi

