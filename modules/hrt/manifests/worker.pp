# Define: hrt::worker
# Example usage:
# hrt::worker { ["worker-1", "worker-2"]: }

define hrt::worker () {

  File {
    owner  => 'root',
    group  => 'root',
  }

  realize File['/etc/init/hrt-worker.conf']

  file { "/etc/init/hrt-${title}.conf":
    ensure => file,
    content => template('hrt/upstart-worker.conf.erb'),
  }

}
