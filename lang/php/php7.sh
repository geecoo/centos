#!/bin/zsh

if [[ -z "$TAR_SRC_DIR" ]];then
    TAR_SRC_DIR="/data/packages/src"
    mkdir -p $TAR_SRC_DIR
fi

function install_php() {
    
    cd "${TAR_SRC_DIR}"

    if [ ! -f "php-7.1.11.tar.gz" ];then 
        wget --no-check-certificate -O php-7.1.11.tar.gz http://cn2.php.net/get/php-7.1.11.tar.gz/from/this/mirror
    fi
    
    tar -xzvf php-7.1.11.tar.gz 

    cd php-7.1.11

    if [[ "$?" -ne 0 ]];then
        echo "not found directory 'php-7.1.11'"
        exit 1
    fi

    ./configure --prefix=/usr/local/php \
    --with-curl \
    --with-freetype-dir \
    --with-gd \
    --with-iconv-dir \
    --with-kerberos \
    --with-libdir=lib64 \
    --with-libxml-dir=/usr \
    --with-openssl \
    --with-pcre-regex \
    --with-pdo-mysql \
    --with-pdo-sqlite \
    --with-pear \
    --with-png-dir \
    --with-jpeg-dir \
    --with-xmlrpc \
    --with-xsl \
    --with-zlib \
    --with-bz2 \
    --with-mhash \
    --enable-fpm \
    --enable-bcmath \
    --enable-libxml \
    --with-imap-ssl \
    --with-mcrypt \
    --enable-mbstring \
    --enable-maintainer-zts \
    --with-config-file-path=/etc \
    --with-config-file-scan-dir=/etc/php.d \
    --enable-mbstring \
    --enable-xml \
    --enable-sockets \
    --enable-pcntl \
    --enable-sysvmsg \
    --enable-sysvshm \
    --enable-shmop \
    --enable-mysqlnd \
    --enable-soap \
    --enable-opcache \
    --enable-zip \
    --enable-sysvmsg \
    --enable-sysvsem \
    --enable-sysvshm \
    --enable-shmop \
    --enable-zend-multibyte \
    --enable-ftp

    #--enable-dtrace
    # --disable-fileinfo

    # 禁用传递其他运行库搜索路径
    #--disable-rpath 

    # 禁止调试模式 
    # --disable-debug
    
    #  virtual memory exhausted: Cannot allocate memory
    #  add --disable-fileinfo
    
    if [[ "$?" -ne 0 ]];then
        echo "php compile failure"
        exit 1
    fi


    make  && make install
 
    if [[ "$?" -ne 0 ]];then
        echo "php install failure "
        exit 1
    fi

}


function init_php_ini() {
    local php_src_dir=${TAR_SRC_DIR}/php-7.1.11
    local php_install_dir=/usr/local/php
    local php_fpm_conf_dir=/usr/local/php/etc/php-fpm.conf

    /usr/bin/cp -f "${php_src_dir}/php.ini-production" /etc/php.ini
    /usr/bin/cp -f "${php_src_dir}/sapi/fpm/init.d.php-fpm.in" /etc/rc.d/init.d/php-fpm

    if [ ! -f /etc/php.ini ];then
        echo "[ERROR] Not found ${php_src_dir}/php.ini-production" 
        exit 1
    fi 
    
    # init php.ini
    sed -i \
    "s@^;date.timezone.*@date.timezone = Asia/Shanghai@; \
     s@^display_errors.*@display_errors = On@; \
     s@^display_startup_errors.*@display_startup_errors = On@; \
     s@^post_max_size.*@post_max_size = 64M@; \
     s@^max_execution_time.*@max_execution_time = 600@; \
     s@^max_input_vars.*@max_input_vars = 1000@; \
     s@^memory_limit.*@memory_limit = 512M@; \
     s@^error_reporting.*@error_reporting = E_ALL@; \
     s@^upload_max_filesize.*@upload_max_filesize = 20M@" \
     /etc/php.ini 

    if [ ! -f /etc/rc.d/init.d/php-fpm ];then
        echo "[ERROR] Not found ${php_src_dir}/sapi/fpm/init.d.php-fpm.in"
        exit 1
    fi 

    sed -i "s@^prefix=.*@prefix=${php_install_dir}@; \
            s/^exec_prefix=.*/exec_prefix=\${prefix}/; \
            s/^php_fpm_BIN=.*/php_fpm_BIN=\${exec_prefix}\/sbin\/php-fpm/; \
            s/^php_fpm_CONF=.*/php_fpm_CONF=\${prefix}\/etc\/php-fpm.conf/; \
            s/^php_fpm_PID=.*/php_fpm_PID=\${prefix}\/var\/run\/php-fpm.pid/" \
            /etc/rc.d/init.d/php-fpm 

    if [[ "$?" -ne 0 ]];then
        echo  "[ERROR] configure php-fpm failure"
        exit 1
    fi 

    chmod +x /etc/rc.d/init.d/php-fpm 

    if [ -f /etc/profile.d/php.sh ];then
        rm -f /etc/profile.d/php.sh 
    fi

    local bin_path="export PATH=/usr/local/php/bin:/usr/local/php/sbin:\$PATH"

    echo "$bin_path" > /etc/profile.d/php.sh 
    . /etc/profile.d/php.sh 


    # php-fpm config #
    
    /usr/bin/cp -f ${php_install_dir}/etc/php-fpm.conf.default ${php_fpm_conf_dir}

    if [[ "$?" -ne 0 ]];then
        echo  "[ERROR] Not found ${php_fpm_conf_dir}, copy failure" 
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
        echo "[ERROR] configure ${php_fpm_conf_dir} failure"
        exit 1
    fi

    cat ${php_fpm_conf_dir} | grep -vE '^;|^[[:space:]]{0,}$'

    echo ${php_fpm_conf_dir}
}

case $1 in
    install)
        install_php
    ;;

    init)
        init_php_ini
    ;;

    *)
        echo "Usage: sh $0 [install | init]"
    ;;
esac 

