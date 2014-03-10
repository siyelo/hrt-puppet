# Class: ubuntu-sources
#
#
class ubuntu-sources {
  apt::source { 'precise-main':
    location   => 'http://za.archive.ubuntu.com/ubuntu/',
    release    => 'precise',
    repos      => 'main universe',
  }

  apt::source { 'precise-security':
    location   => 'http://za.archive.ubuntu.com/ubuntu/',
    release    => 'precise-security',
    repos      => 'main universe',
  }

  apt::source { 'precise-updates':
    location   => 'http://za.archive.ubuntu.com/ubuntu/',
    release    => 'precise-updates',
    repos      => 'main universe',
  }
}