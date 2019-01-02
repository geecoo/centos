#!/bin/bash

file=/etc/ntp/step-tickers
grep 'cn.poll.ntp.org1' $file 1>/dev/null 2>&1
if [ "$?" -ne 0  -a  -f "$file" ];then
    echo '准备输出'
else
    echo '不输出'
fi
