#!/bin/bash
#
#The Shell is ADD new FTP user#
#
while true; do
	read -p "请输入要新建的FTP用户的账号：" ftpname
	if [ -n "$ftpname" ]; then
		if [ $(grep "$ftpname" /etc/vsftpd/virtusers) ]; then
			echo "该用户已存在，请重新输入"
			continue;
		else
			break;
		fi
	else	
		continue;
	fi
done

while true; do
	read -p "请输入密码：" ftppwd
	if [ -n "$ftppwd" ]; then
		break;
	else	
		continue;
	fi
done

echo -e "$ftpname\n$ftppwd" >> /etc/vsftpd/virtusers
db_load -T -t hash -f /etc/vsftpd/virtusers /etc/vsftpd/virtusers.db

mkdir -p /home/wwwroot/$ftpname/http/file
chmod 777 /home/wwwroot/$ftpname/http/file
touch /etc/vsftpd/vconf/$ftpname

echo -e "local_root=/home/wwwroot/$ftpname/http/\nwrite_enable=YES\nanon_world_readable_only=NO\nanon_upload_enable=YES\nanon_mkdir_write_enable=YES\nanon_other_write_enable=YES" >> /etc/vsftpd/vconf/$ftpname
