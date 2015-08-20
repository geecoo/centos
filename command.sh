#!/bin/zsh

cat<<EOF
list command

# mysql
/etc/rc.d/init.d/mysqld start
/etc/rc.d/init.d/mysqld stop
/etc/rc.d/init.d/mysqld restart 
/etc/my.cnf

# composer
curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/local/bin

EOF
