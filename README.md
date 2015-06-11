# CentOS 7 / PHP5 / MongoDB Vagrantfile

Deploy a CentOS 7 based Vagrant machine with basic developer runtime tooling to VirtualBox.

## Dependencies

You will have to install vagrant before the contents of this repo make sense. You might also
want to configure your vagrant instance.

### Linux/Fedora
```bash
sudo yum install ruby-devel libvirt-devel
sudo apt-get install ruby-dev libvirt-dev
defaultzone=$(firewall-cmd --get-default-zone)
sudo firewall-cmd --permanent --zone $defaultzone --add-service mountd
sudo firewall-cmd --permanent --zone $defaultzone --add-service rpc-bind
sudo firewall-cmd --permanent --zone $defaultzone --add-service nfs
sudo firewall-cmd --reload
##VirtualBox Provider
```bash
vagrant plugin install vagrant-vbguest

## Initial Deploy

```bash
git clone https://github.com/gravity-platform/vagrant-centos-7-php.git
cd vagrant-centos-7-php
vagrant up
```

Now you can ``vagrant ssh`` into the box and run composer.

```bash
cd $PATH_TO_HOME_AS_ON_HOST # ie. /home/hairmare/git.repos/graviton
composer install
vendor/bin/phpunit
app/console server:run 0.0.0.0:8000
```

## Update
This should run all tests and start a server on port 8000 that has been mapped on the boxes NAT interface.

You can update the box by redeploying it.

```bash
vagrant destroy
vagrant box update
vagrant up
```

## Configuration

You may add a ``Vagrantfile.local`` file that overrides some defaults.

See [Vagrantfile.local.dist](Vagrantfile.local.dist) for an example config.
