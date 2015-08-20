#!/bin/zsh

sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config

echo "SELINUX status : " $(getenforce)

# reboot

