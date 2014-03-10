# Ruby
# ----
# See [LaunchPad](https://launchpad.net/~brightbox/+archive/ruby-ng)

class brightbox-ruby {

# Packages required to build Ruby 1.9.3
  package { ['libgoogle-perftools-dev', 'libtcmalloc-minimal0']:
    ensure => present,
  }

  apt::ppa { 'ppa:brightbox/ruby-ng': }
  ->
    package { ['libruby1.9.1', 'ruby1.9.1-dev', 'ruby1.9.1', 'rubygems']:
      ensure => installed,
    }

}
