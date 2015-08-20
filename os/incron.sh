#!/bin/zsh

yum install -y incron

systemctl enable incrond
systemctl start incrond
