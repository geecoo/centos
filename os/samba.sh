#!/bin/zsh

# how to install samba service and configure share directory

yum install -y samba*

service smb start

# centos 7 /bin/systemctl restart  smb.service

cat<<EOF
  # /etc/samba/smb.conf
  # Example
  
  [www]
        comment = WWW 
        path = /data/www
        browseable = yes
        guest ok = yes
        writable = yes
  # End 
  
  # must create a exist system user for window auth
  smbpasswd -a geecoo
  
  # Unser the window system
  # 映射网络驱动器 Mapping a network drive 
  # \\192.168.1.22\www
  
EOF
  
