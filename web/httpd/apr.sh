#!/bin/zsh

if [[ -z "$TAR_SRC_DIR" ]];then
    TAR_SRC_DIR="/data/packages/src"
fi

function install_apr() {
    cd $TAR_SRC_DIR

    if [ ! -f "apr-1.5.2.tar.gz" ];then 
        wget --no-check-certificate -O apr-1.5.2.tar.gz http://mirrors.cnnic.cn/apache//apr/apr-1.5.2.tar.gz
    fi
    
    tar -xzvf apr-1.5.2.tar.gz
    cd apr-1.5.2 

    if [[ "$?" -ne 0 ]];then
        echo "not found directory apr-1.5.2 ...no"
        exit 1
    fi
    
    ./configure --prefix=/usr/local/apr

    make -j4 && make install  
    
    if [[ "$?" -ne 0 ]];then
        echo "apr install failure  ...no"
        exit 1
    else
        echo "apr install success ...ok"
    fi
}

case $1 in
    install)
        install_apr
    ;;

    *)
        echo "Usage: sh $0 install"
    ;;
esac 

