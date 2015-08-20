# Initialize all packages

yum install wget  
sh os/init_new_centos7.sh   

git clone https://github.com/geecoo/centos.git && cd centos

sh os/vim/vim-7.4.sh  
sh lamp.sh httpd  
sh lamp.sh percona  
sh lamp.sh php  
 
