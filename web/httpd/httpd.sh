#!/bin/zsh

if [[ -z "$TAR_SRC_DIR" ]];then
    TAR_SRC_DIR="/data/packages/src"
    mkdir -p $TAR_SRC_DIR
fi

function install_apache() {
    cd $TAR_SRC_DIR

    if [ ! -f "httpd-2.4.20.tar.gz" ];then 
        wget --no-check-certificate -O  httpd-2.4.20.tar.gz http://mirrors.cnnic.cn/apache//httpd/httpd-2.4.20.tar.gz    
    fi
    
    tar -xzvf httpd-2.4.20.tar.gz
    cd httpd-2.4.20

    if [[ "$?" -ne 0 ]];then
        echo "not found directory httpd-2.4.20  ...no"
        exit 1
    fi
    
    ./configure --prefix=/usr/local/apache \
    --sysconfdir=/etc/httpd \
    --enable-so \
    --enable-ssl \
    --enable-cgi \
    --enable-rewrite \
    --with-zlib \
    --with-pcre \
    --with-apr=/usr/local/apr \
    --with-apr-util=/usr/local/aprutil \
    --enable-mpms-shared=all \
    --with-mpm=event \
    --enable-modules=most 
    
    make -j4 && make install 

    if [[ "$?" -ne 0 ]];then
        echo -en "\033[0;30;41m httpd install failure  ...no \033[0;37m \n"
        exit 1
    else
        echo -en "\033[0;30;42m httpd install success ...ok \033[0;37m \n"
    fi
   
    echo "export PATH=/usr/local/apache/bin:\$PATH" > /etc/profile.d/httpd.sh
    
    sleep 1

    .  /etc/profile.d/httpd.sh

    iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
}

function init_httpd_conf() {
    local httpd_conf="/etc/httpd/httpd.conf"

    if [ ! -f "$httpd_conf" ];then
        echo "not found $$httpd_conf ... no"
        exit 1
    fi

    sed -ri 's@(^[[:space:]]+DirectoryIndex)( index.html)@\1 index.php\2@' $httpd_conf  
    sed -ri "/$(grep -E "^[[:space:]]+AddType" $httpd_conf | tail -1 | sed 's@/@\\&@')/a \\\tAddType application/x-httpd-php .php" $httpd_conf 

    sed -ri "/$(grep -E "^[[:space:]]+AddType" $httpd_conf | tail -1 | sed 's@/@\\&@')/a \\\tAddType application/x-httpd-php-source .phps" $httpd_conf
    
    sed -i "s@^ServerRoot .*@#&@" $httpd_conf 
    #sed -i "/^Listen 80/a \#Listen 443" $httpd_conf
    sed -i "/^#ServerName.*/a \ServerName 127.0.0.1" $httpd_conf 
    sed -ri "s@^#(Include /etc/httpd/extra/httpd-vhosts.conf)@\1@" $httpd_conf 
    #sed -ri "s@^#(Include /etc/httpd/extra/httpd-ssl.conf)@\1@"  $httpd_conf
    #sed -ri "s@^#(LoadModule ssl_module modules/mod_ssl.so)@\1@" $httpd_conf
    sed -ri "s@^#(LoadModule socache_shmcb_module modules/mod_socache_shmcb.so)@\1@" $httpd_conf
    sed -ri "s@^#(LoadModule proxy_module .*)@\1@" $httpd_conf
    sed -ri "s@^#(LoadModule proxy_fcgi_module.*)@\1@" $httpd_conf
    sed -ri "s@^#(LoadModule rewrite_module modules/mod_rewrite.so)@\1@" $httpd_conf 
    sed -i "s@^DocumentRoot.*@#&@" $httpd_conf 
    sed -i "s@^PidFile.*@PidFile "${APACHE_PATH}/logs/httpd.pid"@" $httpd_conf
    grep '^[^#]' $httpd_conf | grep -vE '^[[:space:]]+#'    
    
    if [[ "$?" -ne 0 ]];then
        echo "init httpd.conf failure ...no"
        exit 1
    else
        echo "init httpd.conf success ...yes"
    fi
}

case $1 in
    install)
        install_apache
    ;;

    init)
        init_httpd_conf
    ;;

    *)
        echo "Usage: sh $0 install"
    ;;
esac 

