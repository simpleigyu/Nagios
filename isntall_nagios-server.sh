#!/bin/bash

yum install -y httpd php gcc glibc glibc-common gd gd-devel make net-snmp
useradd nagios
groupadd nagcmd
usermod -G nagcmd nagios
usermod -G nagcmd apache
sleep 2

cd /usr/local/src/
wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.2.3.tar.gz
wget http://nagios-plugins.org/download/nagios-plugins-2.2.0.tar.gz
tar -zxf nagios-4.2.3.tar.gz
tar -zxf nagios-plugins-2.2.0.tar.gz
cd /usr/local/src/nagios-4.2.3
sleep 1
./configure --with-command-group=nagcmd
make all
make install
make install-init
make install-commandmode
make install-config
make install-webconf
chmod u+s /bin/ping
sleep 1
htpasswd -s -c /usr/local/nagios/etc/htpasswd.users nagiosadmin


sleep 20
systemctl restart httpd.service

cd /usr/local/src/nagios-plugins-2.2.0
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make
make install
sleep 10

mkdir /usr/local/nagios/etc/moniter/
mv /usr/local/nagios/etc/objects/commands.cfg /usr/local/nagios/etc/moniter/
mv /usr/local/nagios/etc/objects/contacts.cfg /usr/local/nagios/etc/moniter/
mv /usr/local/nagios/etc/objects/localhost.cfg /usr/local/nagios/etc/moniter/
mv /usr/local/nagios/etc/objects/printer.cfg /usr/local/nagios/etc/moniter/
mv /usr/local/nagios/etc/objects/switch.cfg /usr/local/nagios/etc/moniter/
mv /usr/local/nagios/etc/objects/templates.cfg /usr/local/nagios/etc/moniter/
mv /usr/local/nagios/etc/objects/timeperiods.cfg /usr/local/nagios/etc/moniter/
mv /usr/local/nagios/etc/objects/windows.cfg /usr/local/nagios/etc/moniter/
mv /usr/local/nagios/etc/objects/ /usr/local/nagios/etc/hosts/
mkdir -p /usr/local/nagios/var/spool/checkresults
chown nagios.nagios -R /usr/local/nagios

-------------------------------------------
wait
-------------------------------------------
