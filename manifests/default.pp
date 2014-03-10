# Default
# =======

# This file describes the default node. This will soon be replaced by something
# allowing you to describe different hosts.

node default {

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

  include ubuntu-sources

  # Apt
  # ---
  # See: [puppetlabs/apt](https://forge.puppetlabs.com/puppetlabs/apt)
  class { 'apt':
    # always_apt_update    => true,
    purge_sources_list   => true,
    # purge_sources_list_d => true,
    # proxy_host           => false,
    # proxy_port           => '8080',
  }

  group { 'puppet':
    ensure => 'present',
  }

  File { owner => 0, group => 0, mode => 0644 }

  file { '/etc/motd':
    content => "Welcome to your Vagrant-built virtual machine!
                Managed by Puppet.\n",
  }

  # Application Account
  # -------------------

  user { 'hrt':
    comment   => 'HRT',
    home      => '/home/hrt',
    ensure    => present,
    managehome => true,
    shell     => '/bin/bash',
    password  => sha1('testing'),
    #uid => '501',
    #gid => '20'
  }


  # Database
  # --------
  # See [puppetlabs/postgresql](https://forge.puppetlabs.com/puppetlabs/postgresql)

  include postgresql::server
  # Development packages for the pg gem
  include postgresql::devel

  Class['postgresql::server']
  ->
  postgresql::role { 'hrt':
    password_hash => postgresql_password('hrt', 'testing'),
    login         => true,
  }
  ->
  postgresql::database { 'hrt':
    owner => 'hrt'
  }

  # Git
  # ---

  package { "git-core":
    ensure => installed,
  }

  # Nginx
  # -----
  # See [puppetlabs/nginx](https://forge.puppetlabs.com/puppetlabs/nginx)

  class { 'nginx': }

  include brightbox-ruby
  class { 'hrt':
    ruby => Class['brightbox-ruby']
  }

  class { 'hrt::web': }
  hrt::worker { ['worker-1','worker-2']: }



  # Developer NTHs
  # --------------

  package { "vim":
    ensure => installed,
  }

  package { 'foreman':
    provider => gem,
    require  => Class['brightbox-ruby'],
  }

}
