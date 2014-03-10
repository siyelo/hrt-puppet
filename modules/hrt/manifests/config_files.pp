# Config Files for the application
# All .yml files in here ideally get used from `/etc/hrt`
# or copying from there during deployment.

class hrt::config_files {

  File {
    ensure => 'present',
    owner  => $hrt::user,
    group  => $hrt::group,
  }

  # Right now the application uses UNIX sockets for this.
  # When this changes, we will need to pull this out and use a define
  # or parameterized class.

  file { "/etc/hrt":
    ensure => 'directory',
  }
  ->
  file { "/etc/hrt/database.yml":
    ensure  => 'present',
    content => template('hrt/database.yml.erb')
  }
}
