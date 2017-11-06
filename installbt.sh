#!/bin/bash

#原版下载
wget -c https://www.51yd.org/YiDuInstaller-V1.1.9Beta-centos7.zip
unzip  YiDuInstaller-V1.1.9Beta-centos7.zip
wget -c https://github.com/olmtv/yidu/archive/master.zip
unzip master.zip
\cp  yidu-master/conf/server.xml  YiDuInstaller/conf/
\cp  yidu-master/ROOT/WEB-INF/classes/log4j.properties    YiDuInstaller/ROOT/WEB-INF/classes/
cd YiDuInstaller


#安装JDK
chmod +x jdk-6u45-linux-x64-rpm.bin
./jdk-6u45-linux-x64-rpm.bin

#安装TOMCAT
tar zxvf apache-tomcat-7.0.55.tar.gz
mv apache-tomcat-7.0.55 /usr/local/tomcat
\cp conf/server.xml /usr/local/tomcat/conf/   #文件有修改
\cp sh/tomcat.sh /etc/profile.d/tomcat.sh
\cp sh/tomcat /etc/rc.d/init.d/tomcat
chmod +x /etc/rc.d/init.d/tomcat

#设置自动启动
chkconfig --add tomcat
chkconfig tomcat on

#rm -rf /www/wwwroot/webapps/ROOT/*  #移除原有文件 ，避免有文件，或者有人建立了这个目录
mkdir -p /www/wwwroot/webapps/ROOT/
mv ROOT/* /www/wwwroot/webapps/ROOT/

#安装数据库
yum -y install ./pgdg-redhat93-9.3-1.noarch.rpm
yum -y install postgresql93-server postgresql93-contrib    
service postgresql-9.3 initdb


#设置开机自动启动
chkconfig postgresql-9.3 on
\cp conf/pg_hba.conf /var/lib/pgsql/9.3/data/pg_hba.conf   #需要覆盖命令

#启动Postgresql
service postgresql-9.3 start

#启动tomcat
service tomcat start


#install spider
mv spider /usr/local/
cp sh/spider /etc/rc.d/init.d/spider
chmod +x /etc/rc.d/init.d/spider
chmod +x /usr/local/spider/start.sh
chmod +x /usr/local/spider/stop.sh
chkconfig --add spider
chkconfig spider on

