#!/bin/bash

if [[ -z "$TAR_SRC_DIR" ]];then
    TAR_SRC_DIR="/data/packages/src"
    mkdir -p $TAR_SRC_DIR
fi

basepath=$(cd `dirname $0`; pwd)

cd $TAR_SRC_DIR

if [ ! -f "node-v6.9.4.tar.gz" ];then 
    wget --no-check-certificate -O  node-v6.9.4.tar.gz https://nodejs.org/dist/v6.9.4/node-v6.9.4.tar.gz 
fi

tar -xzvf node-v6.9.4.tar.gz && cd node-v6.9.4

if [[ "$?" -ne 0 ]];then
    echo "not found directory node-v6.9.4"
    exit 1
fi


./configure --prefix=/usr/local/node 
make && make install

if [[ "$?" -ne 0 ]];then
    echo -en "\033[0;30;41m nodejs install failure  ...no \033[0;37m \n"
    exit 1
else
    echo -en "\033[0;30;42m nodejs install success ...ok \033[0;37m \n"
fi


echo "export PATH=/usr/local/node/bin:\$PATH" > /etc/profile.d/node.sh
    
.  /etc/profile.d/node.sh
