# Class: hrt::upstart
#
#
class hrt::upstart {

  File {
    owner => 'root',
    group => 'root',
    ensure => 'present',
  }

  # Make sure the subdir for the proxnet services is available.
  # Anything thats not supposed to be in there will be deleted.
  # We put the services in a folder so we can manage them with purge.
  file { "/etc/init/hrt":,
    ensure => 'directory',
    purge  => true,
  }
  ->
  file { '/etc/init/hrt.conf':
    content => template("hrt/hrt.conf"),
    alias   => 'hrt upstart'
  }
  ->  # for http://projects.puppetlabs.com/issues/14297
  file { '/etc/init.d/hrt':
    ensure => link,
    target => "/lib/init/upstart-job",
  }

  @file { "/etc/init/hrt-web.conf":,
    ensure => 'present',
    content => template('hrt/hrt-web.conf'),
  }

  @file { "/etc/init/hrt-worker.conf":,
    ensure => 'present',
    content => template('hrt/hrt-worker.conf'),
  }

}
