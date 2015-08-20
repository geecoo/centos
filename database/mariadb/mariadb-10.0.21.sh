#!/bin/zsh

if [[ -z "$SRC_DIR" ]];then
    SRC_DIR="/data/src"
fi

MARIADB_VERSION='10.0.21'

MARIADB_SRC_DIR_NAME="mariadb-${MARIADB_VERSION}"

MARIADB_SRC_DIR="${SRC_PATH}${MARIADB_SRC_DIR_NAME}"

MARIADB_DOWNLOAD_FILENAME="mariadb-${MARIADB_VERSION}.tar.gz"

MARIADB_INSTALL_DIR="/usr/local/mariadb"

function install_mariadb() {
    if [ ! -x ${MARIADB_INSTALL_DIR}/bin/apachectl ]
    then
        auto_install_mariadb
    else
        watchdog "[INFO] mariadb is installed, skip install "
    fi
}

function auto_install_mariadb()
{

    download_mariadb_src

    cd $MARIADB_SRC_DIR

    watchdog "[INFO] compile mariadb ...."
    
    mkdir -p /var/mysql
    
    if [ -f ./CMakeCache.txt ]
    then
        rm -f ./CMakeCache.txt
    fi

    # compile
    cmake . -DCMAKE_INSTALL_PREFIX=${MARIADB_INSTALL_PATH} \
    -DMYSQL_DATADIR=${MARIADB_DATA_PATH} \
    -DSYSCONFDIR=etc \
    -DWITH_SSL=system  \
    -DWITH_SPHINX_STORAGE_ENGINE=1 \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    -DWITH_ARCHIVE_STORAGE_ENGINE=1 \
    -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
    -DWITH_READLINE=1 \
    -DWITH_ZLIB=system \
    -DWITH_LIBWRAP=0 \
    -DMYSQL_UNIX_ADDR=/var/mysql/mysql.sock \
    -DDEFAULT_CHARSET=utf8 \
    -DDEFAULT_COLLATION=utf8_general_ci \
    -DWITH_ARIA_STORAGE_ENGINE=1 \
    -DWITH_XTRADB_STORAGE_ENGINE=1 \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    -DWITH_PARTITION_STORAGE_ENGINE=1 \
    -DWITH_FEDERATEDX_STORAGE_ENGINE=1 \
    -DWITH_MYISAM_STORAGE_ENGINE=1 \
    -DENABLED_LOCAL_INFILE=1 \
    -DWITH_EMBEDDED_SERVER=1 

    make -j4 && make install
    
    if [[ "$?" -ne 0 ]];then
        watchdog  "[ERROR] Install Mariadb failed" ERROR
        exit 1
    fi

    cp ${MARIADB_INSTALL_PATH}/support-files/my-large.cnf /etc/my.cnf 
    cp ${MARIADB_INSTALL_PATH}/support-files/mysql.server /etc/rc.d/init.d/mysqld 
    chmod +x /etc/rc.d/init.d/mysql 
    /usr/sbin/chkconfig --add mysql 
    /usr/sbin/chkconfig --list mysql
    
    sed -i "/^thread_concurrency.*/a \datadir=/mydata/data" /etc/my.cnf 

    /usr/sbin/groupadd mysql
    /usr/sbin/useradd -s /sbin/nologin -M -g mysql mysql
    #/usr/sbin/useradd -g mysql -r -s /sbin/nologin -m -d ${MARIADB_DATA_PATH} mysql  
    chown -R mysql:mysql /usr/local/mysql
    chown -R mysql:mysql ${MARIADB_DATA_PATH} 
    sed -i "$(cat /etc/man.config | grep -nE '^MANPATH[[:space:]]+' | tail -1 | awk -F: '{print$1}')a MANPATH\t/usr/local/mysql/man" /etc/man.config
    echo "export PATH=/usr/local/mysql/bin:\$PATH" > /etc/profile.d/mariadb.sh

}


function download_mariadb_src() 
{
    cd "$SRC_DIR"

    if [ -f ./$MARIADB_DOWNLOAD_FILENAME ]
    then

        watchdog "[INFO] $MARIADB_DOWNLOAD_FILENAME has already downloaded"

    else
        watchdog "[INFO] $MARIADB_DOWNLOAD_FILENAME is downloading..."
        wget --no-check-certificate -O  $MARIADB_DOWNLOAD_FILENAME https://downloads.mariadb.org/interstitial/mariadb-10.0.21/source/${MARIADB_DOWNLOAD_FILENAME}/from/http%3A/mirrors.opencas.cn/mariadb?serve
        
    fi
    
    tar -xzvf ${MARIADB_DOWNLOAD_FILENAME}
}

