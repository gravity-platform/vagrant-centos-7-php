VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT
yum -y install epel-release scl-utils deltarpm && \
yum -y install https://www.softwarecollections.org/en/scls/rhscl/php55/epel-7-x86_64/download/rhscl-php55-epel-7-x86_64.noarch.rpm && \
yum -y update && \
yum -y install php55 php55-php-mongo php55-php-pdo php55-php-devel mongodb mongodb-server && \
systemctl enable mongod && \
systemctl start mongod && \
echo '. /opt/rh/php55/enable' >> /home/vagrant/.bashrc && \
echo 'export X_SCLS="`scl enable php55 'echo \$X_SCLS'`"'  >> /home/vagrant/.bashrc && \
. /opt/rh/php55/enable && \
export X_SCLS="`scl enable php55 'echo $X_SCLS'`" && \
echo 'memory_limit=-1' > /opt/rh/php55/root/etc/php.d/memory_limit.ini && \
pecl install xdebug && \
echo 'zend_extension=xdebug.so' > /opt/rh/php55/root/etc/php.d/xdebug.ini && \
curl -sS https://getcomposer.org/installer | php && \
mv composer.phar /usr/local/bin/composer && \
firewall-cmd --zone=public --add-port=8000/tcp --permanent && \
firewall-cmd --reload
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "fernandezvara/centos7"

  config.vm.synced_folder ENV['HOME'], ENV['HOME'], id: "home", :nfs => true, :mount_options => ['nolock,vers=3,udp']

  config.vm.network "private_network", type: "dhcp"

  config.vm.network "forwarded_port",
    guest: 8000,
    host_ip: '127.0.0.1', host: 8000,
    auto_correct: true

  config.vm.provision "shell", inline: $script

end
