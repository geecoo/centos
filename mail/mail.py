#!usr/bin/python
#-*- coding: UTF-8 -*-
import os, sys
reload(sys)
sys.setdefaultencoding('utf-8')
import getopt
import smtplib
from email.MIMEText import MIMEText
from email.MIMEMultipart import MIMEMultipart
from  subprocess import *

def sendqqmail(username,password,mailfrom,mailto,subject,content):
    # 这里要修改为你邮箱的smtp服务地址，例如163邮箱的话，就是：smtp.163.com
    gserver = 'smtp.qq.com'
    gport = 465
    try:
        msg = MIMEText(unicode(content).encode('utf-8'))
        msg['from'] = mailfrom
        msg['to'] = mailto
        msg['Reply-To'] = mailfrom
        msg['Subject'] = subject
        smtp = smtplib.SMTP(gserver, gport)
        smtp.set_debuglevel(1)
        smtp.ehlo()
        smtp.login(username,password)
        smtp.sendmail(mailfrom, mailto, msg.as_string())
        smtp.close()
    except Exception,err:
        print "Send mail failed. Error: %s" % err

def main():
    to=sys.argv[1]
    subject=sys.argv[2]
    content=sys.argv[3]
##定义邮箱的账号和密码，你需要修改成你自己的账号和密码
    sendqqmail('511429563@qq.com','svbuxtdnnqlvbjda','511429563@qq.com',to,subject,content)
if __name__ == "__main__":
    main()

