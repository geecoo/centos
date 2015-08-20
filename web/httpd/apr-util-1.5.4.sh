#!/bin/zsh

if [[ -z "$TAR_SRC_DIR" ]];then
    TAR_SRC_DIR="/data/src"
fi

function install_apr_util() {
    cd $TAR_SRC_DIR

    if [ ! -f "apr-util-1.5.4.tar.gz" ];then 
        wget --no-check-certificate -O apr-util-1.5.4.tar.gz http://mirrors.cnnic.cn/apache//apr/apr-util-1.5.4.tar.gz
    fi
    
    tar -xzvf apr-util-1.5.4.tar.gz    

    cd apr-util-1.5.4 

    if [[ "$?" -ne 0 ]];then
        echo "not found directory apr-util-1.5.4  ...no"
        exit 1
    fi
 
    ./configure --prefix=/usr/local/aprutil --with-apr=/usr/local/apr
    make -j4 && make install   

    if [[ "$?" -ne 0 ]];then
        echo -en "\033[0;30;41m apr-util install failure  ...no \033[0;37m \n"
        exit 1
    else
        echo -en "\033[0;30;42m apr-util install success ...ok \033[0;37m \n"
    fi
}

case $1 in
    install)
        install_apr_util
    ;;

    *)
        echo "Usage: sh $0 install"
    ;;
esac 

