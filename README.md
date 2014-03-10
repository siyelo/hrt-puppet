HRT Puppet
==================

This repo contains the puppet recipies for the box required to run
HRT.


Development
-----------

The development process is orchestrated via Vagrant and Puppet.
Development is done in MRI 1.9.3.

To install new modules from the puppet forge:

    puppet module install username/module --modulepath ./modules

We have to add an explicit `--modulepath` when installing from your development
environment, so that the module will be installed into the recipie directory
and not `/etc`.


Development Quick-start
-----------------------

Install Puppet on your machine

    gem install puppet

Download and Install [Vagrant](http://downloads.vagrantup.com/)

    vagrant up
    vagrant provision
