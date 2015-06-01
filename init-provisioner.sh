#!/bin/bash
#
# This script installs all necessary packages and dependencies
#
if [ -z "$1" ]; then
    phpVersion=55
else
    phpVersion=$1
fi

echo "====== start installation ======"

yum -y install epel-release scl-utils deltarpm
yum -y install https://www.softwarecollections.org/en/scls/rhscl/php$phpVersion/epel-7-x86_64/download/rhscl-php$phpVersion-epel-7-x86_64.noarch.rpm
yum -y install https://www.softwarecollections.org/en/scls/remi/php$phpVersion\more/epel-7-x86_64/download/remi-php$phpVersion\more-epel-7-x86_64.noarch.rpm
yum -y update

yum -y install php$phpVersion php$phpVersion-php-pecl-mongo php$phpVersion-php-pdo php$phpVersion-php-pecl-xdebug  mongodb mongodb-server
yum -y install git

echo "====== installation finished ======"
echo "====== start configuration ======"

echo ". /opt/rh/php$phpVersion/enable" >> /home/vagrant/.bashrc
echo "export X_SCLS='`scl enable php$phpVersion 'echo \$X_SCLS'`'"  >> /home/vagrant/.bashrc
. /opt/rh/php$phpVersion/enable
export X_SCLS="`scl enable php$phpVersion 'echo $X_SCLS'`"

phpRoot="/opt/rh/php$phpVersion/root/"
sed -i "/zend_extension=xdebug.so/c\zend_extension=$phpRoot\usr/lib64/php/modules/xdebug.so" $phpRoot\etc/php.d/xdebug.ini
echo 'xdebug.remote_enable=On' >> $phpRoot\etc/php.d/xdebug.ini
echo 'xdebug.remote_port=9001' >> $phpRoot\etc/php.d/xdebug.ini
echo 'xdebug.remote_autostart=On' >> $phpRoot\etc/php.d/xdebug.ini
echo 'xdebug.remote_connect_back=On' >> $phpRoot\etc/php.d/xdebug.ini
echo 'xdebug.idekey=PHPSTORM' >> $phpRoot\etc/php.d/xdebug.ini
# echo 'xdebug.remote_log=/tmp/xdebug.log' >> $phpRoot\etc/php.d/xdebug.ini

echo 'export XDEBUG_CONFIG="idekey=PHPSTORM"' >> /home/vagrant/.bashrc

systemctl enable mongod
systemctl start mongod

curl -sS https://getcomposer.org/installer | php && \
mv composer.phar /usr/local/bin/composer && \

firewall-cmd --zone=public --add-port=8080/tcp --permanent && \
firewall-cmd --reload
