#!/bin/zsh
# more http://www.pool.ntp.org/zh/

# sync local time 
yum install -y ntpdate

echo 'cn.poll.ntp.org' >> /etc/ntp/step-tickers
sed -i 's/^SYNC_HWCLOCK=no/SYNC_HWCLOCK=yes/' /etc/sysconfig/ntpdate

systemctl status ntpdate
systemctl enable ntpdate
systemctl start ntpdate
