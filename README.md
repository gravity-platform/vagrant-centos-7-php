# CentOS 7 / PHP5 / MongoDB Vagrantfile

Deploy a CentOS 7 based Vagrant machine with basic developer runtime tooling to VirtualBox.

## Dependencies

You will have to install vagrant before the contents of this repo make sense. You might also
want to configure your vagrant instance.

```bash
vagrant plugin install vagrant-vbguest
```

On Windows you should also install [winNFSd](https://github.com/winnfsd/vagrant-winnfsd):

```bash
vagrant plugin install vagrant-winnfsd
```

### Versions
- vagrant version >= 1.7
- vagrant plugin 'vagrant-vbguest' (latest)
- vagrant plugin 'vagrant-winnfsd' (latest, on Windows only)

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


## Default Ports
The following services are available under the defined host ports:
| Service                                 | Port  | Notes                  |
|:----------------------------------------|:-----:|:-----------------------|
| **Graviton**                            | 8000  |                        |
| **MongoDB**                             | 27017 |                        |
| **RabbitMQ**                            | 5672  |                        |
| **RabbitMQ Management (Web Interface)** | 15672 | Login with guest:guest |