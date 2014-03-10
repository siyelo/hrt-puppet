# Class: passenger
#
#
class passenger {
  
  apt::source { 'passenger':
    location   => 'https://oss-binaries.phusionpassenger.com/apt/passenger',
    repos      => 'main',
    key        => '561F9B9CAC40B2F7',
    key_server => 'keyserver.ubuntu.com',
  } 
  ->
  package { "passenger":
    ensure => installed,
  }

}