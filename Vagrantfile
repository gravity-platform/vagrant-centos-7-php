VAGRANTFILE_API_VERSION = "2"

ipAddr = nil

if File.exists?('Vagrantfile.local')
  load 'Vagrantfile.local'
end

$script = <<SCRIPT
yum -y install epel-release scl-utils deltarpm && \
yum -y install https://www.softwarecollections.org/en/scls/rhscl/php55/epel-7-x86_64/download/rhscl-php55-epel-7-x86_64.noarch.rpm && \
yum -y update && \
yum -y install php55 php55-php-mongo php55-php-pdo php55-php-devel mongodb mongodb-server git && \
systemctl enable mongod && \
systemctl start mongod && \
echo '. /opt/rh/php55/enable' >> /home/vagrant/.bashrc && \
echo 'export X_SCLS="`scl enable php55 'echo \$X_SCLS'`"'  >> /home/vagrant/.bashrc && \
. /opt/rh/php55/enable && \
export X_SCLS="`scl enable php55 'echo $X_SCLS'`" && \
echo 'memory_limit=-1' > /opt/rh/php55/root/etc/php.d/memory_limit.ini && \
pecl install xdebug && \
echo 'zend_extension=xdebug.so' > /opt/rh/php55/root/etc/php.d/xdebug.ini && \
echo 'xdebug.remote_enable=On' >> /opt/rh/php55/root/etc/php.d/xdebug.ini && \
echo 'xdebug.remote_port=9001' >> /opt/rh/php55/root/etc/php.d/xdebug.ini && \
echo 'xdebug.remote_autostart=On' >> /opt/rh/php55/root/etc/php.d/xdebug.ini && \
echo 'xdebug.remote_connect_back=On' >> /opt/rh/php55/root/etc/php.d/xdebug.ini && \
echo 'xdebug.idekey=PHPSTORM' >> /opt/rh/php55/root/etc/php.d/xdebug.ini && \
echo 'export XDEBUG_CONFIG="idekey=PHPSTORM"' >> /home/vagrant/.bashrc && \
curl -sS https://getcomposer.org/installer | php && \
mv composer.phar /usr/local/bin/composer && \
echo '#/bin/sh' > /usr/local/bin/vagrant-centos-7-php-wrapper.sh && \
echo >> /usr/local/bin/vagrant-centos-7-php-wrapper.sh && \
echo 'REQUESTED_BIN=`basename ${0}`' >> /usr/local/bin/vagrant-centos-7-php-wrapper.sh && \
echo 'if [[ -f ${PWD}/vendor/bin/${REQUESTED_BIN} ]]; then' >> /usr/local/bin/vagrant-centos-7-php-wrapper.sh && \
echo '    FINAL_BIN=${PWD}/vendor/bin/${REQUESTED_BIN}' >> /usr/local/bin/vagrant-centos-7-php-wrapper.sh && \
echo 'else' >> /usr/local/bin/vagrant-centos-7-php-wrapper.sh && \
echo '    FINAL_BIN=${HOME}/.composer/vendor/bin/${REQUESTED_BIN}' >> /usr/local/bin/vagrant-centos-7-php-wrapper.sh && \
echo 'fi' >> /usr/local/bin/vagrant-centos-7-php-wrapper.sh && \
echo 'exec $FINAL_BIN $@' >> /usr/local/bin/vagrant-centos-7-php-wrapper.sh && \
chmod +x /usr/local/bin/vagrant-centos-7-php-wrapper.sh && \
su -l vagrant -c 'composer global require phpunit/phpunit' && \
ln -s vagrant-centos-7-php-wrapper.sh /usr/local/bin/phpunit && \
su -l vagrant -c 'composer global require squizlabs/php_codesniffer' && \
ln -s vagrant-centos-7-php-wrapper.sh /usr/local/bin/phpcs && \
ln -s vagrant-centos-7-php-wrapper.sh /usr/local/bin/phpcbf && \
firewall-cmd --zone=public --add-port=8000/tcp --permanent && \
firewall-cmd --reload
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "fernandezvara/centos7"

  config.vm.provider "virtualbox" do |vbox|
    vbox.memory = 2048
  end

  config.vm.synced_folder ENV['HOME'], ENV['HOME'], id: "home", :type => 'nfs', :nfs_version => 4, :nfs_udp => false, :mount_options => ['nolock']

  if ipAddr.nil?
    config.vm.network "private_network", type: "dhcp"
  else
    config.vm.network :private_network, ip: ipAddr
  end

  config.vm.network "forwarded_port",
    guest: 8000,
    host_ip: '127.0.0.1', host: 8000,
    auto_correct: true

  config.vm.provision "shell", inline: $script

end
