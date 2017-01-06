#!/bin/bash
#
# rpm -qa | grep php
# uninstall old php version
rm -f /etc/php.*

rpm -e php-devel-5.4.16-36.1.el7_2.1.x86_64
rpm -e php-cli-5.4.16-36.1.el7_2.1.x86_64
rpm -e php-common-5.4.16-36.1.el7_2.1.x86_64

rm -fr /usr/lib64/php/modules
rm -fr /usr/local/php
rm -fr /etc/init.d/php-fpm
