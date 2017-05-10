#!/bin/bash
#Disable SELinux
PATH=`pwd`

sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/selinux/config

#Update system

yum -y update
yum -y groupinstall core base "Development Tools"
yum -y install lynx figlet mariadb-server mariadb php php-mysql php-mbstring tftp-server httpd ncurses-devel sendmail sendmail-cf sox newt-devel libxml2-devel libtiff-devel audiofile-devel gtk2-devel subversion kernel-devel git php-process crontabs cronie cronie-anacron wget vim php-xml uuid-devel sqlite-devel net-tools gnutls-devel php-pear unixODBC mysql-connector-odbc

#Install pear requirement
pear install Console_Getopt
systemctl enable mariadb.service
systemctl start mariadb
echo -e "\n\n\n\n\n\nn\n\n " | mysql_secure_installation 2>/dev/null
systemctl enable httpd.service
systemctl start httpd.service

#Add asterisk user
adduser asterisk -M -c "Asterisk User"

#Configure asterisk
cd $PATH/src/dahdi-linux
make all
make install
make config
cd $PATH/src/libpri
make
make install
cd /$PATH/src/jansson
autoreconf -i
./configure --libdir=/usr/lib64
make
make install

cd $PATH/src/asterisk
patch -p1 < ../cisco-usecallmanager-13.15.0.patch
contrib/scripts/install_prereq install
./configure --libdir=/usr/lib64
make
make install
make samples
make config
ldconfig
chkconfig asterisk off
#Asterisk Soundfiles install
cp -rv $PATH/sounds/* /var/lib/asterisk/sounds/

#Setting permissions
chown asterisk. /var/run/asterisk
chown -R asterisk. /etc/asterisk
chown -R asterisk. /var/{lib,log,spool}/asterisk
chown -R asterisk. /usr/lib64/asterisk
chown -R asterisk. /var/www/

#Configure FreePbx

sed -i 's/\(^upload_max_filesize = \).*/\120M/' /etc/php.ini
sed -i 's/^\(User\|Group\).*/\1 asterisk/' /etc/httpd/conf/httpd.conf
sed -i 's/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf
systemctl restart httpd.service

cd $PATH/freepbx
./start_asterisk start
./install -n
cp $PATH/freepbx.service /etc/systemd/system/
systemctl enable freepbx.service
systemctl restart freepbx
echo "/usr/bin/figlet IPT PBX" >> ~/.bash_profile
reboot

#Script by James PS | IPtechnics LLC
