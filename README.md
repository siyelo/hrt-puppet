Proxnet Pro Puppet
==================

Below is the documentation for the Proxnet Pro Linux Installation.

This repo contains the puppet recipies for the infrastructure required to run
Proxnet Pro.


Development
-----------

The development process is orchestrated via Vagrant and Puppet.  
Despite ProxnetPro using ruby 1.8.7 for production, the development 
infrastructure is written against 1.9.2-p329 and Puppet 2.7.

To install new modules from the puppet forge:

    puppet module install username/module --modulepath ./modules

We have to add an explicit `--modulepath` when installing from your development
environment, so that the module will be installed into the recipie directory
and not `/etc`.


Development Quick-start
-----------------------

Install Puppet on your machine

    gem install puppet -v=3.2.4

Download and Install [Vagrant](http://downloads.vagrantup.com/)

    vagrant up
    vagrant provision

Deploying ProxnetPro in Development
-----------------------------------

TODO

Ensuring Puppet > 3
-------------------

On Vagrant's Precise images, you will find Puppet 2.7. These modules were
written with Puppet 3 in mind.

Follow the example [here](http://blog.doismellburning.co.uk/2013/01/19/upgrading-puppet-in-vagrant-boxes/) for help on getting Puppet up to date.