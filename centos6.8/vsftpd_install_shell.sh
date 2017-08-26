#!/bin/bash
# centos6.8
#The Shell is install and config to The VSftpd Server for The Centos7#
#


if [ $USER != "root" ]; then	
	echo "Please use root account operation or sudo"
	exit 1
fi

if [ $( rpm -qa vsftpd ) ];then
	echo "VSftpd已安装";
else
	echo "开始安装VSFTPD，安装完后自动配置，请等待";

#安装VSFTPD#
yum install -y vsftpd
yum install -y psmisc net-tools systemd-devel libdb-devel perl-DBI
service vsftpd start
chkconfig --level 35 vsftpd on 

#配置VSFTPD#
cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf-bak

sed -i "s/anonymous_enable=YES/anonymous_enable=NO/g" '/etc/vsftpd/vsftpd.conf'

sed -i "s/#anon_upload_enable=YES/anon_upload_enable=NO/g" '/etc/vsftpd/vsftpd.conf'

sed -i "s/#anon_mkdir_write_enable=YES/anon_mkdir_write_enable=YES/g" '/etc/vsftpd/vsftpd.conf'

sed -i "s/#chown_uploads=YES/chown_uploads=NO/g" '/etc/vsftpd/vsftpd.conf'

sed -i "s/#async_abor_enable=YES/async_abor_enable=YES/g" '/etc/vsftpd/vsftpd.conf'

sed -i "s/#ascii_upload_enable=YES/ascii_upload_enable=YES/g" '/etc/vsftpd/vsftpd.conf'

sed -i "s/#ascii_download_enable=YES/ascii_download_enable=YES/g" '/etc/vsftpd/vsftpd.conf'

sed -i "s/#ftpd_banner=Welcome to blah FTP service./ftpd_banner=Welcome to FTP service./g" '/etc/vsftpd/vsftpd.conf'
#guest_username 这里要改为root
echo -e "use_localtime=YES\nlisten_port=21\nchroot_local_user=YES\nidle_session_timeout=300\ndata_connection_timeout=1\nguest_enable=YES\nguest_username=zealous\nuser_config_dir=/etc/vsftpd/vconf\nvirtual_use_local_privs=YES\npasv_min_port=10060\npasv_max_port=10090\naccept_timeout=5\nconnect_timeout=1" >> /etc/vsftpd/vsftpd.conf


#---------------------------------------------------------------------#

#关闭SELINUX#
sed -i "s/SELINUX=enforcing/#SELINUX=enforcing/g" /etc/selinux/config
sed -i "s/SELINUXTYPE=targeted/#SELINUXTYPE=targeted/g" /etc/selinux/config
echo -e "SELINUX=disabled\n" >> /etc/selinux/config
#使配置立即生效#
setenforce 0

#---------------------------------------------------------------------#

touch /etc/vsftpd/virtusers

#建立用户和密码#
echo -e "zealous\n123456" >> /etc/vsftpd/virtusers
#生成虚拟用户数据文件#
db_load -T -t hash -f /etc/vsftpd/virtusers /etc/vsftpd/virtusers.db
chmod 600 /etc/vsftpd/virtusers.db

#---------------------------------------------------------------------#

#在 /etc/pam.d/vsftpd 的文件头部加入信息#
cp /etc/pam.d/vsftpd /etc/pam.d/vsftpdbak

sed -i "1a\account sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/virtusers" /etc/pam.d/vsftpd
sed -i "1a\auth sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/virtusers" /etc/pam.d/vsftpd
#注意：如果系统为32位，则把lib64改为lib，否则无效#





#创建配置文件 #
mkdir /etc/vsftpd/vconf
touch /etc/vsftpd/vconf/zealous

#改目录
echo -e "local_root=/home/share/share/\nwrite_enable=YES\nanon_world_readable_only=NO\nanon_upload_enable=YES\nanon_mkdir_write_enable=YES\nanon_other_write_enable=YES" >> /etc/vsftpd/vconf/zealous

#重启VSFTPD#
service vsftpd restart 

fi
#-----------------------------------------------------------------------------#