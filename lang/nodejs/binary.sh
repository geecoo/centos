#!/bin/bash

if [[ -z "$TAR_SRC_DIR" ]];then
    TAR_SRC_DIR="/data/packages/src"
    mkdir -p $TAR_SRC_DIR
fi

basepath=$(cd `dirname $0`; pwd)

cd $TAR_SRC_DIR

if [ ! -f "node-v6.9.4-linux-x64.tar.xz" ];then 
    wget --no-check-certificate -O  node-v6.9.4-linux-x64.tar.xz https://nodejs.org/dist/v6.9.4/node-v6.9.4-linux-x64.tar.xz
fi

tar -xvf node-v6.9.4-linux-x64.tar.xz && mv node-v6.9.4-linux-x64 /usr/local/node

if [[ "$?" -ne 0 ]];then
    echo -en "\033[0;30;41m nodejs( binary ) install failure  ...no \033[0;37m \n"
    exit 1
else
    echo -en "\033[0;30;42m nodejs( binary ) install success ...ok \033[0;37m \n"
fi


echo "export PATH=/usr/local/node/bin:\$PATH" > /etc/profile.d/node.sh
    
.  /etc/profile.d/node.sh
