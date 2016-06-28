* 配置IP

```
   vi /etc/sysconfig/network-scripts/ifcfg-eno16777736  
   配置好ip, 参考 os/ifcfg.sh

   service network restart
   service network status
```

>如果是虚拟机， 选择桥接模式, 到这一步， 虚拟机已连通网络


* 初始化centos环境

```
   yum install -y wget git
   git clone https://github.com/geecoo/centos.git && cd centos
   sh os/init_centos7.sh
```

* 安装vim 
```
sh os/vim/vim-7.4.sh  
```

* 初始化dotfiles
```
cd ~ && git clone https://github.com/geecoo/dotfiles.git && cd dotfiles && source bin/dotfile install
PlugInstall [name ...] [#threads]
PlugStatus
cd ~/.vim/bundle/Trinity/plugin && rm -f NERD_tree.vim
```

* 安装apache
```
   source lamp.sh httpd  
```


*  安装数据库percona
```  
 source lamp.sh percona 
```

* 安装php
```
   先清理系统中的旧版本
   rpm -qa | grep php
   rpm -e 完整包名
   source lang/php/uninstall.sh
   
   # install
   source lamp.sh php 
   配套扩展(yaf, redis, memcached, imagemagick)默认没有安装 
   请到lang/php下自行执行对应的脚本
   
   如果安装出错，执行以下步骤,清理所有已安装的php数据
   1. rm -fr /usr/lib64/php/modules
   2. rm -f /etc/php.*
   3. rm -fr /usr/local/php
```

* 卸载软件
```
rpm -qa | grep php
rpm -e 完整包名
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



