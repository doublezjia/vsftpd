#!/bin/bash
#
#The Shell is install and config iptables#
#


if [ $USER != "root" ]; then	
	echo "请用root 或者 sudo 来运行"
	exit 1
fi

if [ $( rpm -qa iptables ) ]; then
	echo "已安装 iptables";
else
	echo "现在开始安装 iptables";




#------------------------------------------------------------------------------#
##安装和配置iptables##

yum install -y iptables

fi

yum update iptables
yum install -y iptables-services

#禁用/停止自带的firewalld服务#
systemctl stop firewalld
systemctl mask firewalld

iptables -P INPUT ACCEPT
iptables -F 
iptables -X
iptables -Z
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 21 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 10060:10090 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 8 -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP
service iptables save
systemctl enable iptables.service
systemctl restart iptables.service

#------------------------------------------------------------------------------#

#关闭firewall#
# systemctl stop firewalld.service
# systemctl disable firewalld.service

# #安装iptables防火墙#
# yum install iptables.services

# #配置iptables#

# echo -e "#Firewall configuration written by system-config-firewall\n#Manual customization of this file is not recommended.\n*filter\n:INPUT ACCEPT [0:0]\n:FORWARD ACCEPT [0:0]\n:OUTPUT ACCEPT [0:0]\n-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT\n-A INPUT -p icmp -j ACCEPT\n-A INPUT -i lo -j ACCEPT\n-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT\n-A INPUT -m state --state NEW -m tcp -p tcp --dport 21 -j ACCEPT\n-A INPUT -m state --state NEW -m tcp -p tcp --dport 10060:10090 -j ACCEPT\n-A INPUT -j REJECT --reject-with icmp-host-prohibited\n-A FORWARD -j REJECT --reject-with icmp-host-prohibited\nCOMMIT" >> /etc/sysconfig/iptables

# #重启防火墙，设置开机启动#
# systemctl restart iptables.service
# systemctl enable iptables.service
 

#-------------------------------------------------------------------------------------#