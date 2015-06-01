# CentOS 7 / PHP5 / MongoDB Vagrantfile

Deploy a CentOS 7 based Vagrant machine with basic developer runtime tooling to VirtualBox.

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

The following example shows all configurable aspects of the system.

```ruby
ipAddr = "192.168.50.20"
```

