VAGRANTFILE_API_VERSION = "2"

module Box
  module Config
    attr_accessor :ipAddr, :syncDirHost, :syncDirGuest, :xdebugIdeKey
    module_function :ipAddr, :ipAddr=, :syncDirHost, :syncDirHost=, :syncDirGuest, :syncDirGuest=, :xdebugIdeKey, :xdebugIdeKey=
    # set defaults
    @syncDirHost = ENV['HOME']
    @syncDirGuest = ENV['HOME']
    @xdebugIdeKey = "XDEBUG_SESSION"
  end
end

if File.exists?('Vagrantfile.local')
  load 'Vagrantfile.local'
end

$script = <<SCRIPT
yum -y install epel-release scl-utils deltarpm && \
yum -y install https://www.softwarecollections.org/en/scls/rhscl/rh-php56/epel-7-x86_64/download/rhscl-rh-php56-epel-7-x86_64.noarch.rpm && \
yum -y update && \
yum -y install rh-php56 rh-php56-php-mongo rh-php56-php-pdo rh-php56-php-devel rh-php56-php-bcmath rh-php56-php-mbstring rh-php56-php-pecl-xdebug mongodb mongodb-server rabbitmq-server git && \
sed -i -e 's/bind_ip = 127.0.0.1/#bind_ip = 127.0.0.1/g' /etc/mongod.conf && \
systemctl enable mongod && \
systemctl start mongod && \
echo '. /opt/rh/rh-php56/enable' >> /home/vagrant/.bashrc && \
echo 'export X_SCLS="`scl enable rh-php56 'echo \$X_SCLS'`"'  >> /home/vagrant/.bashrc && \
. /opt/rh/rh-php56/enable && \
export X_SCLS="`scl enable rh-php56 'echo $X_SCLS'`" && \
echo 'memory_limit=-1' > /etc/opt/rh/rh-php56/php.d/memory_limit.ini && \
echo 'xdebug.remote_enable=On' > /etc/opt/rh/rh-php56/php.d/xdebug.ini && \
echo 'xdebug.remote_port=9001' >> /etc/opt/rh/rh-php56/php.d/xdebug.ini && \
echo 'xdebug.remote_autostart=On' >> /etc/opt/rh/rh-php56/php.d/xdebug.ini && \
echo 'xdebug.remote_connect_back=On' >> /etc/opt/rh/rh-php56/php.d/xdebug.ini && \
echo 'xdebug.idekey=#{Box::Config::xdebugIdeKey}' >> /etc/opt/rh/rh-php56/php.d/xdebug.ini && \
echo \"export XDEBUG_CONFIG='idekey=#{Box::Config::xdebugIdeKey} remote_enable=1 remote_autostart=1 remote_host=#{`hostname`[0..-2]}'\" >> /home/vagrant/.bashrc
curl -sS https://getcomposer.org/installer | php && \
mv composer.phar /usr/local/bin/composer && \
cp /vagrant/vendor-wrapper.sh /usr/local/bin/vagrant-centos-7-php-wrapper.sh && \
chmod +x /usr/local/bin/vagrant-centos-7-php-wrapper.sh && \
su -l vagrant -c 'composer global require phpunit/phpunit' && \
ln -s vagrant-centos-7-php-wrapper.sh /usr/local/bin/phpunit && \
su -l vagrant -c 'composer global require squizlabs/php_codesniffer' && \
ln -s vagrant-centos-7-php-wrapper.sh /usr/local/bin/phpcs && \
ln -s vagrant-centos-7-php-wrapper.sh /usr/local/bin/phpcbf && \
systemctl enable rabbitmq-server && \
systemctl start rabbitmq-server && \
rabbitmq-plugins enable rabbitmq_management && \
firewall-cmd --zone=public --add-port=8000/tcp --permanent && \
firewall-cmd --zone=public --add-port=27017/tcp --permanent && \
firewall-cmd --zone=public --add-port=5672/tcp --permanent && \
firewall-cmd --zone=public --add-port=15672/tcp --permanent && \
firewall-cmd --reload
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "bento/centos-7.2"
  
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    v.memory = 2048
  end

  if Vagrant::Util::Platform.windows?
     config.vm.synced_folder Box::Config::syncDirHost, Box::Config::syncDirGuest, id: "home", :type => 'nfs', :nfs_version => 3, :nfs_udp => true, :mount_options => ['nolock,vers=3,udp']
  else
    config.vm.synced_folder Box::Config::syncDirHost, Box::Config::syncDirGuest, id: "home", :type => 'nfs', :nfs_version => 4, :nfs_udp => false, :mount_options => ['nolock']
  end

  if Box::Config::ipAddr.nil?
    config.vm.network "private_network", type: "dhcp"
  else
    config.vm.network :private_network, ip: Box::Config::ipAddr
  end

  config.vm.network "forwarded_port",
    guest: 8000,
    host_ip: '127.0.0.1', host: 8000,
    auto_correct: true

  config.vm.network "forwarded_port",
    guest: 27017,
    host_ip: '127.0.0.1', host: 27017,
    auto_correct: true
  
  config.vm.network "forwarded_port",
    guest: 5672,
    host_ip: '127.0.0.1', host: 5672,
    auto_correct: true

  config.vm.network "forwarded_port",
    guest: 15672,
    host_ip: '127.0.0.1', host: 15672,
    auto_correct: true

  config.vm.provision "vendor-wrapper", type: "file",
    source: "vendor-wrapper.sh",
    destination: "vendor-wrapper.sh"

  config.vm.provision "shell", inline: $script

end
