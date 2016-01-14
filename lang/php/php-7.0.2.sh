#!/bin/zsh

if [[ -z "$TAR_SRC_DIR" ]];then
    TAR_SRC_DIR="/data/src"
fi

function install_php() {
    
    cd "${TAR_SRC_DIR}"

    if [ ! -f "php-7.0.2.tar.gz" ];then 
        wget --no-check-certificate -O php-7.0.2.tar.gz http://cn2.php.net/get/php-7.0.2.tar.gz/from/this/mirror
    fi
    
    tar -xzvf php-7.0.2.tar.gz 

    cd php-7.0.2

    if [[ "$?" -ne 0 ]];then
        watchdog "Not found directory 'php-7.0.2'" ERROR
        exit 1
    fi

    ./configure --prefix=/usr/local/php \
    --with-mysql=mysqlnd \
    --with-pdo-mysql=mysqlnd \
    --with-mysqli=mysqlnd \
    --with-openssl \
    --enable-mbstring \
    --with-freetype-dir \
    --with-jpeg-dir \
    --with-png-dir \
    --with-zlib \
    --with-libxml-dir=/usr \
    --enable-xml \
    --enable-sockets \
    --enable-pcntl \
    --enable-fpm \
    --enable-soap \
    --with-gd \
    --with-mcrypt \
    --with-curl \
    --with-config-file-path=/etc \
    --with-config-file-scan-dir=/etc/php.d \
    --with-bz2 \
    --with-apxs2=/usr/local/apache/bin/apxs \
    --enable-maintainer-zts  \
    --enable-bcmath \
    --enable-intl  \
    --enable-zip
    #--disable-fileinfo
    
    #  virtual memory exhausted: Cannot allocate memory
    #  add --disable-fileinfo
    
    if [[ "$?" -ne 0 ]];then
        watchdog "php compile failure" ERROR
        exit 1
    fi


    make -j$(grep processor /proc/cpuinfo | wc -l) && make install
 
    if [[ "$?" -ne 0 ]];then
        watchdog "php make install failure " ERROR
        exit 1
    fi
   
#    echo "export PATH=/usr/local/php/bin:/usr/local/php/sbin:\$PATH" > /etc/profile.d/php.sh
    
#    .  /etc/profile.d/httpd.sh
}

function watchdog() {
    echo -en "\n"
    echo "##" $(pwd)

    case $2 in
    ERROR|ERR)
         echo -en "\033[0;30;41m" ;;
    *)
         echo -en "\033[0;30;42m" ;;
    esac
    
    echo -en "$message\033[0;37m \n" 
}

function init_php_ini() {
    local php_src_dir=${TAR_SRC_DIR}/php-7.0.2
    local php_install_dir=/usr/local/php
    local php_fpm_conf_dir=/usr/local/php/etc/php-fpm.conf

    cp "${php_src_dir}/php.ini-production" /etc/php.ini
    cp "${php_src_dir}/sapi/fpm/init.d.php-fpm.in" /etc/rc.d/init.d/php-fpm

    if [ ! -f /etc/php.ini ];then
        watchdog "[ERROR] Not found ${php_src_dir}/php.ini-productioni" ERROR 
        exit 1
    fi 

    source init.php.ini.sh    

    if [ ! -f /etc/rc.d/init.d/php-fpm ];then
        watchdog "[ERROR] Not found ${php_src_dir}/sapi/fpm/init.d.php-fpm.in" ERROR 
        exit 1
    fi 

    sed -i "s@^prefix=.*@prefix=${php_install_dir}@; \
            s/^exec_prefix=.*/exec_prefix=\${prefix}/; \
            s/^php_fpm_BIN=.*/php_fpm_BIN=\${exec_prefix}\/sbin\/php-fpm/; \
            s/^php_fpm_CONF=.*/php_fpm_CONF=\${prefix}\/etc\/php-fpm.conf/; \
            s/^php_fpm_PID=.*/php_fpm_PID=\${prefix}\/var\/run\/php-fpm.pid/" \
            /etc/rc.d/init.d/php-fpm 

    if [[ "$?" -ne 0 ]];then
        watchdog  "[ERROR] configure php-fpm failure" ERROR 
        exit 1
    fi 

    chmod +x /etc/rc.d/init.d/php-fpm 

    if [ -f /etc/profile.d/php.sh ];then
        rm -f /etc/profile.d/php.sh 
    fi

    local bin_path="export PATH=/usr/local/php/bin:/usr/local/php/sbin:\$PATH"

    echo "$bin_path" > /etc/profile.d/php.sh 
    . /etc/profile.d/php.sh 

    cp ${php_install_dir}/etc/php-fpm.conf.default ${php_fpm_conf_dir}

    if [[ "$?" -ne 0 ]];then
        watchdog  "[ERROR] Not found ${php_fpm_conf_dir}, copy failure" ERROR 
        exit 1
    fi 


    sed -i "s@^pm.max_children.*@pm.max_children = 50@; \
            s@^pm.start_servers.*@pm.start_servers = 5@; \
            s@^pm.min_spare_servers.*@pm.min_spare_servers = 2@; \
            s@^pm.max_spare_servers.*@pm.max_spare_servers = 8@;" \
            ${php_fpm_conf_dir}

    sed -i "s@;pid = .*@pid = ${php_install_dir}/var/run/php-fpm.pid@" ${php_fpm_conf_dir}

    #sed -i "s@^listen.*@listen = $(ifconfig eth0 | awk -F'[ :]+' '/inet addr/{print$4}'):9000@" ${PHP_INSTALL_DIR}/etc/php-fpm.conf 
    sed -i "s@^listen.*@listen = 127.0.0.1:9000@" ${php_fpm_conf_dir} 
    
    if [[ "$?" -ne 0 ]];then
        watchdog "[ERROR] configure ${php_fpm_conf_dir} failure" ERROR
        exit 1
    fi

    cat ${php_fpm_conf_dir} | grep -vE '^;|^[[:space:]]{0,}$'

    echo ${php_fpm_conf_dir}
}

case $1 in
    install)
        if [ -f "/usr/local/apache/bin/apxs" ];then
            install_php
        else
            watchdog "Please install apache" ERROR
        fi
    ;;

    init)
        init_php_ini
    ;;

    *)
        echo "Usage: sh $0 [install | init]"
    ;;
esac 

