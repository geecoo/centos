#!/bin/zsh

# crontab , centos 7 default install

yum install -y cronie
chkconfig crond on
service crond start
