tcp_nodelay 和 tcp_nopush
这两个指令影响nginx的底层网络，它们决定操作系统如何处理网络层buffer和什么时候把buffer内容刷新给终端用户

指令tcp_nodelay作用于socket参数TCP_NODELAY。


在这之前，我们先说说nagle缓存算法，有些应用程序在网络通讯的时候会发送很少的字节，比如说一个字节，那么再加TCP协议本身，实际上发的要41个字节，这样的效率是很低的。这时候nagle算法就应运而生了，它将要发送的数据存放在缓存里，当积累到一定量或一定时间，再将它们发送出去。

这里TCP_NODELAY就是nagle启用与否的开关，所以下面的指令的效果就是禁用nagle算法，也即不缓存数据。

tcp_nodelay on;