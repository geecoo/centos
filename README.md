
* 配置本地IP

```
vi /etc/sysconfig/network-scripts/ifcfg-eno16777736  (网卡配置文件可能不同)
配置ip参考 os/ifcfg.sh

service network restart
service network status
```

>如果是虚拟机， 选择桥接模式, 到这一步， 虚拟机已连通网络

* Usage
> bin/geecoo -h

> ( bin/geecoo --module PHP --do install --invoke install )


* 初始化Centos环境

```
yum install -y wget git
git clone https://github.com/geecoo/centos.git && cd centos
bin/geecoo --module os --do isys
```

* 安装 Vim

```
bin/geecoo --module os --do vim  

# 初始化dotfiles, 包含Vim 插件、profile.d、 alias

cd ~ && git clone https://github.com/geecoo/dotfiles.git && cd dotfiles && source bin/dotfile install
PlugInstall [name ...] [#threads]
PlugStatus
cd ~/.vim/bundle/Trinity/plugin && rm -f NERD_tree.vim
```

* 安装Apache
```
bin/geecoo --module httpd --do install 
bin/geecoo --module httpd --do conf
```

* 安装 Nginx
```
bin/geecoo --module nginx --do install  (包含 nginx.conf 和 启动脚本)
```

*  安装数据库percona
```  
bin/geecoo --module percona --do install  
```

* 安装PHP

```
clear all php directory and binary package
bin/geecoo --module php --do clear
   
# install
bin/geecoo --module php --do install --invoke install
   
# ini php.ini
bin/geecoo --module php --do install --invoke ini
   
# install php extension
bin/geecoo --module php --do yaf
bin/geecoo --module php --do swoole
...
   
# 手动处理
如果安装出错，执行以下步骤,清理所有已安装的php数据
rpm -qa | grep php
rpm -e 完整包名
rm -fr /usr/lib64/php/modules
rm -f /etc/php.*
rm -fr /usr/local/php
   
```

* 卸载软件
```
rpm -qa | grep php
rpm -e 完整包名
```

* 验证sh脚本是否正确
```
sh -n  xxx.sh   语法检测
sh -v  xxx.sh   打印脚本原始命令
sh -x  xxx.sh   打印代码执行时的过程(执行顺序和结果)
```

* Git 配置参考

配置文件存储： ~/.gitconfig

git config --global user.name "geecoo"

git config --global user.email jackjie009@gmail.com 

git config --global core.editor vim

git config --global merge.tool vimdiff

单独查看用户名
git config user.name

查看全局配置
git config --list 

三种方式获取命令help
git help < verb >  
git < verb > --help
man git-< verb >

< END Git >



