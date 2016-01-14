1. vi /etc/sysconfig/network-scripts/ifcfg-eno16777736  
   配置好ip, 参考 os/ifcfg.sh

2. 如果是虚拟机， 用桥接模式

3. 到这一步， 网络已连通 

4. yum install -y wget git

   git clone https://github.com/geecoo/centos.git && cd centos

完成以上命令，请根据需要执行相应的命令

1) 初始化centos 7 环境
sh os/init_new_centos7.sh   

2) 安装vim 
sh os/vim/vim-7.4.sh  

3) 安装apache
   sh lamp.sh httpd  

4) 安装数据库percona
   sh lamp.sh percona 

5) 安装php
   sh lamp.sh php 
   配套扩展(yaf, redis, memcached, imagemagick)默认没有安装 
   请到lang/php下自行执行对应的脚本



卸载软件
rpm -qa | grep php
rpm -e 完整包名

