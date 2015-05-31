VAGRANTFILE_API_VERSION = "2"

ipAddr = "192.168.50.2"
phpVersion = "55"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "fernandezvara/centos7"

  config.vm.network "private_network", ip: ipAddr

  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.synced_folder ENV['HOME'], ENV['HOME'], type: "nfs", nfs_export: false

  config.vm.provision "shell", path: "init-provisioner.sh", args: phpVersion
  # config.vm.provision "shell", inline: "cd graviton/ && /opt/rh/php" + phpVersion + "/root/usr/bin/php app/console server:start " + ipAddr + ":8080", run: "always", privileged: "false"
end
