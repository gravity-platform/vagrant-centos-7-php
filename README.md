# CentOS 7 / PHP5 / MongoDB Vagrantfile

Deploy a CentOS 7 based Vagrant machine with basic developer runtime tooling to VirtualBox.

## Dependencies

You will have to install vagrant before the contents of this repo make sense. You might also
want to configure your vagrant instance.

```bash
vagrant plugin install vagrant-vbguest # vbguest keeps guest-additions up2 date
vagrant plugin install vagrant-winnfsd # nfs support for windows based hosts
```

### Versions
- vagrant version >= 1.7
- vagrant plugin 'vagrant-vbguest' (latest)

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
