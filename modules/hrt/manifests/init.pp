# HRT Application
# =======================

class hrt ($ruby) {

  # Default Variables
  # -----------------

  $user =     'hrt'
  $group =    'hrt'
  $home_dir = '/home/hrt'
  $app_dir =  "${home_dir}/app"

  # Git deploy directory
  # --------------------

  deployable { "hrt" :
    repo_dir   => "${home_dir}/git",
    deploy_dir => $app_dir,
  }

  # Configuration Files
  # -------------------

  include '::hrt::config_files'

  # Web Workers
  # -----------

  File {
    ensure  => 'directory',
    owner   => $user,
    group   => $group,
    mode    => 744,
  }

  file { "/var/log/hrt":
    alias  => 'hrt log folder',
  }

  file { "${home_dir}/app":
    alias  => 'hrt app folder',
  }

  # Upstart
  # -------

  file { "${app_dir}/public":
    ensure => 'directory',
  }

  file { "${app_dir}/public/index.html":
    ensure => 'present',
    content => 'It works!',
  }

  file { "${app_dir}/tmp":
    ensure => 'directory',
    purge => true,
  }

  # Base Gems
  # ---------
  # We need the base gems before any app servers can be started.

  include '::hrt::gems'

  # Phusion Passenger
  # -----------------

  include 'passenger'

  # Dependency Graph
  # ----------------

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up.  You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues

  anchor { 'hrt::begin': }
  anchor { 'hrt::end': }

  Anchor['hrt::begin']
  -> $ruby
  -> Class['::hrt::gems']
  -> Class['hrt::web']
  ~> Service['hrt']
  -> Anchor['hrt::end']

  Anchor['hrt::begin']
  -> Class['passenger']
  -> Class['hrt::web']
  -> Anchor['hrt::end']

  # Services
  # --------

  # Bring in the main upstart script, and subfolder
  include 'hrt::upstart'

  # This is the 'master' service, modifying the state of this service affects
  # the web and worker services.
  service { "hrt":
    ensure     => 'running',
    provider   => 'upstart',
    hasrestart => 'true',
    hasstatus  => 'true',
    require    => Class['upstart'],
  }

  # Any changes to these files will trigger the service to restart.
  Class['upstart']         ~> Service['hrt']
  Class['hrt::web'] ~> Service['hrt']
  Hrt::Worker <| |> ~> Service['hrt']


}
