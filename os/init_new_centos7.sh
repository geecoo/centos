#!/bin/bash

# vi /etc/sysconfig/network-scripts/ifcfg-eno16777736 

# 1. first set timezone
$(yes|cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime)

# 2. install yum fast mirror  
yum install -y yum-plugin-fastestmirror

# 3. update software, kernel
yum clean all
yum update -y

# 4. install all develop package
yum remove -y dhclient dhcp-*

# install ntpdate service
yum install -y ntpdate
echo 'cn.poll.ntp.org' >> /etc/ntp/step-tickers
sed -i 's/^SYNC_HWCLOCK=no/SYNC_HWCLOCK=yes/' /etc/sysconfig/ntpdate   
systemctl status ntpdate
systemctl enable ntpdate
systemctl start ntpdate

# install all packages
LIST_PACKS=(
wget \
unzip \
bzip2 \
telnet \
rsync \
patch \
net-tools \
python \
python-devel \
make \
cmake \
autoconf \
automake  \
gcc-c++ \
gcc \ 
curl \
curl-devel \
libcurl \
libcurl-devel  \
libxml2 \
libxml2-devel  \
bzip2*  \
mhash  \
mhash-devel \
pcre \
pcre-devel \
openssl \
openssl-devel \
zlib-devel \
php-devel \
gd \
freetype \
freetype-devel \
libjpeg \
libjpeg-devel \
libpng \
libpng-devel  \
libicu \
libicu-devel \
gtk+-devel \ 
compat* \
cpp \
glibc \
libgomp \
libstdc++-devel \
keyutils-libs-devel \
libsepol-devel \
libselinux-devel \
krb5-devel \
libXpm*   \
fontconfig \
fontconfig-devel \
ncurses* \
readline* \
libaio* \
libtool* \
perl-ExtUtils-Embed \
svn \
git 
)

for packagename in "${LIST_PACKS[@]}"
do
    yum install -y "$packagename"
done

unset $LIST_PACKS
unset $packagename


#yum -y groupinstall "Development tools" "Server Platform Development"  

# 5. disable selinux
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config
getenforce

# 6. disable firewall
yum install iptables-services -y

systemctl stop firewalld
systemctl disable firewalld

#systemctl start iptables
#systemctl enable iptables
systemctl stop iptables
systemctl disable iptables

#systemctl start ip6tables
#systemctl enable ip6tables
systemctl stop ip6tables
systemctl disable ip6tables

# 7 . add epel 
rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

yum install -y mcrypt libmcrypt libmcrypt-devel

# yum install fast
yum install -y yum-axelget

# 7. reboot
#reboot
