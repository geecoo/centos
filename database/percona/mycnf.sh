#!/bin/zsh

PERCONA_DATA_DIR=/data/percona
PERCONA_INSTALL_DIR=/usr/local/percona

function init_percona_my_cnf() {
    local install_dir=${PERCONA_INSTALL_DIR}
    local data_dir=${PERCONA_DATA_DIR} 

    # my.cf
    if [ -f "/etc/my.cnf" ];then
        mv /etc/my.cnf /tmp/my.cnf
    fi

    cp ${install_dir}/support-files/mysql.server /etc/init.d/mysqld
    chmod +x /etc/init.d/mysqld
    chkconfig --add mysqld
    chkconfig mysqld on
 
    echo  "init percona's my.conf"
    reset_percona_my_cnf

    echo "create user 'mysql' ,ensure user exists"

    id -u mysql >/dev/null 2>&1
    [ $? -ne 0 ] && useradd -M -s /sbin/nologin mysql

    mkdir -p $data_dir 

    if [[ "$?" -ne 0 ]];then
        echo "mkdir $data_dir failure ...no"
        exit 1
    fi

    chown mysql:mysql -R $data_dir

    echo "start execute script mysql_install_db for init db"

    ${install_dir}/scripts/mysql_install_db --user=mysql --basedir=${install_dir} --datadir=${data_dir}
 
    /etc/init.d/mysqld  start     
    
    if [[ "$?" -ne 0 ]];then
        echo "start up mysqld failure ... no"
        exit 1
    else
        echo "export PATH=${install_dir}/bin:\$PATH" > /etc/profile.d/percona.sh
    fi 
    

    rm -rf /etc/ld.so.conf.d/{mysql,mariadb,percona}*.conf
    echo "${install_dir}/lib" > /etc/ld.so.conf.d/percona.conf
    ldconfig

    /etc/init.d/mysqld stop

    if [[ "$?" -ne 0 ]];then
        echo "stop mysqld failure ...no"
        exit 1
    else
        echo "stop mysqld success ...yes"
    fi
}

function reset_percona_my_cnf() {
# my.cnf
cat > /etc/my.cnf << EOF
[client]
port = 3306
socket = ${PERCONA_DATA_DIR}/mysqld.sock
default-character-set = utf8

[mysqld]
port = 3306
socket = ${PERCONA_DATA_DIR}/mysqld.sock

basedir = ${PERCONA_INSTALL_DIR}
datadir = ${PERCONA_DATA_DIR}
pid-file = ${PERCONA_DATA_DIR}/mysqld.pid
user = mysql
bind-address = 0.0.0.0
server-id = 1

init-connect = 'SET NAMES utf8'
character-set-server = utf8

skip-name-resolve
#skip-networking
back_log = 300

max_connections = 1000
max_connect_errors = 6000
open_files_limit = 65535
table_open_cache = 128 
max_allowed_packet = 4M
binlog_cache_size = 1M
max_heap_table_size = 8M
tmp_table_size = 16M

read_buffer_size = 2M
read_rnd_buffer_size = 8M
sort_buffer_size = 8M
join_buffer_size = 8M
key_buffer_size = 4M

thread_cache_size = 8

query_cache_type = 1
query_cache_size = 8M
query_cache_limit = 2M

ft_min_word_len = 4

log_bin = mysql-bin
binlog_format = mixed
expire_logs_days = 30

log_error = ${PERCONA_DATA_DIR}/mysql-error.log
slow_query_log = 1
long_query_time = 1
slow_query_log_file = ${PERCONA_DATA_DIR}/mysql-slow.log

performance_schema = 0
explicit_defaults_for_timestamp

#lower_case_table_names = 1

skip-external-locking

default_storage_engine = InnoDB
#default-storage-engine = MyISAM
innodb_file_per_table = 1
innodb_open_files = 500
innodb_buffer_pool_size = 64M
innodb_write_io_threads = 4
innodb_read_io_threads = 4
innodb_thread_concurrency = 0
innodb_purge_threads = 1
innodb_flush_log_at_trx_commit = 2
innodb_log_buffer_size = 2M
innodb_log_file_size = 32M
innodb_log_files_in_group = 3
innodb_max_dirty_pages_pct = 90
innodb_lock_wait_timeout = 120

bulk_insert_buffer_size = 8M
myisam_sort_buffer_size = 8M
myisam_max_sort_file_size = 10G
myisam_repair_threads = 1

#federated  
#event_scheduler = 1
interactive_timeout = 28800
wait_timeout = 28800

[mysqldump]
quick
max_allowed_packet = 16M

[myisamchk]
key_buffer_size = 8M
sort_buffer_size = 8M
read_buffer = 4M
write_buffer = 4M
EOF


    local mem=$(free -m | awk '/Mem:/{print $2}')

    if [ $mem -gt 1500 ] && [ $mem -le 2500 ]
    then

        sed -i 's@^thread_cache_size.*@thread_cache_size = 16@' /etc/my.cnf
        sed -i 's@^query_cache_size.*@query_cache_size = 16M@' /etc/my.cnf
        sed -i 's@^myisam_sort_buffer_size.*@myisam_sort_buffer_size = 16M@' /etc/my.cnf
        sed -i 's@^key_buffer_size.*@key_buffer_size = 16M@' /etc/my.cnf
        sed -i 's@^innodb_buffer_pool_size.*@innodb_buffer_pool_size = 128M@' /etc/my.cnf
        sed -i 's@^tmp_table_size.*@tmp_table_size = 32M@' /etc/my.cnf
        sed -i 's@^table_open_cache.*@table_open_cache = 256@' /etc/my.cnf

    elif [ $mem -gt 2500 ] && [ $mem -le 3500 ]
    then

        sed -i 's@^thread_cache_size.*@thread_cache_size = 32@' /etc/my.cnf
        sed -i 's@^query_cache_size.*@query_cache_size = 32M@' /etc/my.cnf
        sed -i 's@^myisam_sort_buffer_size.*@myisam_sort_buffer_size = 32M@' /etc/my.cnf
        sed -i 's@^key_buffer_size.*@key_buffer_size = 64M@' /etc/my.cnf
        sed -i 's@^innodb_buffer_pool_size.*@innodb_buffer_pool_size = 512M@' /etc/my.cnf
        sed -i 's@^tmp_table_size.*@tmp_table_size = 64M@' /etc/my.cnf
        sed -i 's@^table_open_cache.*@table_open_cache = 512@' /etc/my.cnf

    elif [ $mem -gt 3500 ]
    then
        sed -i 's@^thread_cache_size.*@thread_cache_size = 64@' /etc/my.cnf
        sed -i 's@^query_cache_size.*@query_cache_size = 64M@' /etc/my.cnf
        sed -i 's@^myisam_sort_buffer_size.*@myisam_sort_buffer_size = 64M@' /etc/my.cnf
        sed -i 's@^key_buffer_size.*@key_buffer_size = 256M@' /etc/my.cnf
        sed -i 's@^innodb_buffer_pool_size.*@innodb_buffer_pool_size = 1024M@' /etc/my.cnf
        sed -i 's@^tmp_table_size.*@tmp_table_size = 128M@' /etc/my.cnf
        sed -i 's@^table_open_cache.*@table_open_cache = 1024@' /etc/my.cnf
    fi 
}

function init_sys_table() {
cat<<EOF
    cd ${PERCONA_INSTALL_DIR}
    scripts/mysql_install_db

    ## login mysql
    mysql> grant all privileges on *.* to root@'127.0.0.1' identified by "123456" with grant option;
    mysql> grant all privileges on *.* to root@'localhost' identified by "123456" with grant option;
    mysql> grant all privileges on *.* to 'root'@'%' identified by "123456" with grant option;
    mysql> delete from mysql.user where Password='';
    mysql> delete from mysql.db where User='';
    mysql> delete from mysql.proxies_priv where Host!='localhost';
    mysql> drop database test;
    ## reset master;
EOF
}


case $1 in
    install)
        init_percona_my_cnf
    ;;

    init)
        init_sys_table
    ;;

    *)
        echo "Usage : sh $0 [ install | init ]"
    ;;
esac
