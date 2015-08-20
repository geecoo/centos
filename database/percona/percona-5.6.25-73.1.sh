#!/bin/zsh

if [[ -z "$TAR_SRC_DIR" ]];then
    TAR_SRC_DIR="/data/src"
fi

PERCONA_DATA_DIR="/data/percona"

function install_percona() {
    cd $TAR_SRC_DIR

    id -u mysql >/dev/null 2>&1
    [ $? -ne 0 ] && useradd -M -s /sbin/nologin mysql

    if [ ! -f "percona-server-5.6.25-73.1.tar.gz" ];then 
        wget --no-check-certificate -O  percona-server-5.6.25-73.1.tar.gz https://www.percona.com/downloads/Percona-Server-5.6/Percona-Server-5.6.25-73.1/source/tarball/percona-server-5.6.25-73.1.tar.gz
    fi
    
    tar -xzvf percona-server-5.6.25-73.1.tar.gz

    cd percona-server-5.6.25-73.1

    if [[ "$?" -ne 0 ]];then
        echo "not found directory percona-server-5.6.25-73.1 ...no"
        exit 1
    fi

    if [ -f ./CMakeCache.txt ];then
        rm -f ./CMakeCache.txt
    fi

    # compile
    # -DDEFAULT_CHARSET=utf8mb4, include utf8 
    # optimize memory use  ljemalloc / ltcmalloc
    # -DBUILD_CONFIG=xtrabackup_release
    
    cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/percona \
        -DMYSQL_DATADIR=${PERCONA_DATA_DIR} \
        -DSYSCONFDIR=/etc \
        -DWITH_INNOBASE_STORAGE_ENGINE=1 \
        -DWITH_PARTITION_STORAGE_ENGINE=1 \
        -DWITH_FEDERATED_STORAGE_ENGINE=1 \
        -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
        -DWITH_MYISAM_STORAGE_ENGINE=1 \
        -DWITH_ARCHIVE_STORAGE_ENGINE=1 \
        -DENABLED_LOCAL_INFILE=1 \
        -DENABLE_DTRACE=0 \
        -DDEFAULT_CHARSET=utf8 \
        -DDEFAULT_COLLATION=utf8_general_ci \
        -DMYSQL_TCP_PORT=3306 \
        -DMYSQL_UNIX_ADDR=${PERCONA_DATA_DIR}/mysqld.sock \
        -DWITH_EMBEDDED_SERVER=OFF 

    if [[ "$?" -ne 0 ]];then
        echo -en "\033[0;30;41m percona compile failure \033[0;37m "
        exit 1
    fi

    make -j `grep processor /proc/cpuinfo | wc -l` && make install
    if [[ "$?" -ne 0 ]];then
        echo "\033[0;30;41m percona make install failure \033[0;37m "
        exit 1
    else
        echo "percona install success ...ok"
    fi
}

case $1 in
    install)
        install_percona
    ;;

    *)
        echo "Usage sh $0 install"
    ;;
esac 

