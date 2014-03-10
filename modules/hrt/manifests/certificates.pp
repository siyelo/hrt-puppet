# Class: hrt::certificates
#
#
class hrt::certificates {

  file { "/etc/nginx/ssl":
    ensure => directory,
  }
  ->
  file { "/etc/nginx/ssl/server.crt":
    ensure => file,
    content => template('hrt/server.crt'),
  }
  ->
  file { "/etc/nginx/ssl/server.key":
    ensure => file,
    content => template('hrt/server.key'),
  }

}
