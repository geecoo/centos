
* 配置本地IP

```
vi /etc/sysconfig/network-scripts/ifcfg-eno16777736  (网卡配置文件可能不同)
配置ip参考脚本 src/os/ifcfg

service network restart
service network status
```

* 排查虚拟机无法联网、或重启后，网络不通
```
VM 还原默认配置

VM 虚拟网络编辑器 -> Vmnet0 -> 桥接模式， 勾选真实网卡

网络适配器 -> 桥接模式 -> 勾选 '复制物理网络连接状态'
(虚拟机删除网络适配器，重新添加一块新的)

配置网卡 ifcfg-eth0
(网关和DNS要设置正确)

重启网卡 service network restart

查看路由配置, 可清理掉，重启网卡，会自动生产新路由表
(route -n) 

重启虚拟机
```

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

* 安装Apache [ 未开发 ]
```
bin/geecoo --module httpd --do install 
bin/geecoo --module httpd --do conf
```

* 安装 Nginx
```
bin/geecoo --module nginx --do install  (包含 nginx.conf 和 启动脚本)
```

*  安装数据库percona [ 未开发 ]
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
```
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
```


* PHP 7.3 最新版本编译扩展失败
##### solor
```

1. src/php7/php_solr.c
   PHP_ME(SolrDocument, __clone, NULL, ZEND_ACC_PUBLIC | ZEND_ACC_CLONE)
   PHP_ME(SolrInputDocument, __clone, NULL, ZEND_ACC_PUBLIC | ZEND_ACC_CLONE)
   PHP_ME(SolrClient, __clone, NULL, ZEND_ACC_PUBLIC | ZEND_ACC_CLONE)
   PHP_ME(SolrParams, __clone, NULL, ZEND_ACC_PUBLIC | ZEND_ACC_CLONE)
   把文件中所有的ZEND_ACC_CLONE去掉
   
2. src/php7/solr_functions_helpers.c
   把文件中的函数 solr_pcre_replace_into_buffer 换成以下函数
   static inline int solr_pcre_replace_into_buffer(solr_string_t *buffer, char * search, char *replace)
{
    zend_string *result;
    zval replace_val;
    int limit = -1;
    int replace_count = -1;
    zend_string *regex_str = zend_string_init(search, strlen(search), 0);
    zend_string *subject_str = zend_string_init(buffer->str, buffer->len, 0);
    #if PHP_VERSION_ID >= 70200
        zend_string *replace_str = zend_string_init(replace, strlen(replace), 0);
    #else
        zval replace_val;
        ZVAL_STRING(&replace_val, replace);
    #endif
    result = php_pcre_replace(
            regex_str,
            subject_str,
            buffer->str,
            buffer->len,
            #if PHP_VERSION_ID >= 70200
                replace_str,
            #else
                &replace_val,
                0
            #endif
            limit,
            &replace_count
    );

    solr_string_set_ex(buffer, (solr_char_t *)result->val, (size_t)result->len);
/*    fprintf(stdout, "%s", buffer->str); */
    efree(result);
    #if PHP_VERSION_ID >= 70200
        zend_string_release(replace_str);
    #else
        zval_ptr_dtor(&replace_val);
    #endif
    zend_string_release(regex_str);
    zend_string_release(subject_str);

    return SUCCESS;
}


相关记录
https://bugs.php.net/bug.php?id=74736
https://git.php.net/?p=pecl/search_engine/solr.git;a=commit;h=744e32915d5989101267ed2c84a407c582dc6f31
https://blog.51cto.com/3502902/2336742?source=dra
```

#### yaf
```
yaf-3.0.7/yaf_session.c
找到ZEND_WRONG_PROPERTY_OFFSET所在位置，更换以下判断，版本7.3不支持常量ZEND_WRONG_PROPERTY_OFFSET
#if PHP_VERSION_ID < 70300
   if (property_info->offset != ZEND_WRONG_PROPERTY_OFFSET)
#else
    if (IS_VALID_PROPERTY_OFFSET(property_info->offset))
#endif
```

