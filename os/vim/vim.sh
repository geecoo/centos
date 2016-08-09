#!/bin/zsh

cd /usr/local/src

# check depends on
yum install -y gcc libX11-devel libXtst-devel ncurses-devel perl-ExtUtils-Embed ruby ruby-devel python-devel gtk2-devel libXt-devel

if [ ! -f "vim-7.4.tar.bz2" ] || [ ! -f "vim-7.4.tar" ];then
    wget -O vim-7.4.tar.bz2 ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2
    bzip2 -d vim-7.4.tar.bz2
fi

# import
if [ -f "/usr/bin/xsubpp" ] && [ ! -f "/usr/share/perl5/ExtUtils/xsubpp" ];then
    ln -s /usr/bin/xsubpp /usr/share/perl5/ExtUtils/xsubpp
fi

tar -xf vim-7.4.tar

cd vim74

./configure \
--with-features=huge \
--enable-rubyinterp \
--enable-pythoninterp \
--enable-multibyte \
--with-python-config-dir=/usr/lib/python2.7/config/ \
--enable-perlinterp \
--enable-gui=gtk2 \
--enable-cscope \
--prefix=/usr \
--enable-luainterp \
--enable-multibyte \
--disable-selinux

make VIMRUNTIMEDIR=/usr/share/vim/vim74 && make install

if [[ "$?" -ne 0 ]];then
    echo "[ERROR] install vim failure"
else
    echo "[SUCESS] install vim ok"
fi
