#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";
SCRIPT_ROOT_DIR=$(pwd -P)
cd $SCRIPT_ROOT_DIR

. ./bootstrap.sh

signal_exit()
{
        echo "\n Ctrl + c.\n"
        exit 0
}

trap "signal_exit" TERM INT HUP

usage() {
    echo ""
    echo "Usage: sh $0 [httpd | percona | php | nginx]"
    echo ""
}

TAR_SRC_DIR="/data/packages/src"
if [[ ! -d "/data/packages/src" ]];then
    mkdir -p /data/packages/src
fi

case $1 in
    httpd)
        source "${SCRIPT_ROOT_DIR}/web/httpd/apr.sh" install
        source "${SCRIPT_ROOT_DIR}/web/httpd/apr-util.sh" install
        source "${SCRIPT_ROOT_DIR}/web/httpd/httpd.sh" install
        source "${SCRIPT_ROOT_DIR}/web/httpd/httpd.sh" init
    ;;

    percona)
        source "${SCRIPT_ROOT_DIR}/database/percona/percona.sh" install
        source "${SCRIPT_ROOT_DIR}/database/percona/mycnf.sh" install
    ;;
    
    php)
        source "${SCRIPT_ROOT_DIR}/lang/php/php.sh" install
        source "${SCRIPT_ROOT_DIR}/lang/php/ini.sh" init
    ;;

    php7)
        sh "${SCRIPT_ROOT_DIR}/lang/php/php7.sh" install
        sh "${SCRIPT_ROOT_DIR}/lang/php/php7.sh" init
    ;;

    *)
        usage
    ;;
esac

