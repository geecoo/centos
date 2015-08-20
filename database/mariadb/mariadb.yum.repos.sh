#!/bin/zsh

# add mariadb yum.repos

NOWDATE=$(date +"%Y-%m-%d %R:%S")

cat > /etc/yum.repos.d/MariaDB.repo <<EOF
# MariaDB 10.1 CentOS repository list - created ${NOWDATE} UTC
# http://mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

