# Class: hrt::gems
#
#
class hrt::gems {

  Package {
    ensure    => installed,
    provider  => gem,
  }

  package { "bundler": ensure => '1.3.5' }

}
