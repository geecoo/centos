#!/bin/zsh
# get absolute path

CUR_SCRIPT_DIR=`dirname $0`

cd "${CUR_SCRIPT_DIR}"

SCRIPT_ROOT_DIR=$(pwd)
. ./bootstrap.sh

signal_exit()
{
        echo "Ctrl + c.\n"
        exit 0
}

trap "signal_exit" TERM INT HUP

usage() {
    echo ""
    echo "Usage: sh $0 [httpd | percona | php]"
    echo ""
}

case $1 in
    httpd)
        sh "${SCRIPT_ROOT_DIR}/web/httpd/apr-1.5.2.sh" install
        sh "${SCRIPT_ROOT_DIR}/web/httpd/apr-util-1.5.4.sh" install
        sh "${SCRIPT_ROOT_DIR}/web/httpd/httpd-2.4.16.sh" install
        sh "${SCRIPT_ROOT_DIR}/web/httpd/httpd-2.4.16.sh" init
    ;;

    percona)
        sh "${SCRIPT_ROOT_DIR}/database/percona/percona-5.6.25-73.1.sh" install
        sh "${SCRIPT_ROOT_DIR}/database/percona/conf.sh" install
        #first_init_account
    ;;
    
    php)
        sh "${SCRIPT_ROOT_DIR}/lang/php/php-5.6.11.1.sh" install
        sh "${SCRIPT_ROOT_DIR}/lang/php/php-5.6.11.1.sh" init
    ;;

    *)
        usage
    ;;
esac

