# Git and Deploy scripts
# ======================
# From: https://github.com/puppetmodules/puppet-module-git/blob/master/manifests/repo.pp

define hrt::deployable ($repo_dir, $deploy_dir) {

  $owner    = $hrt::user
  $group    = $hrt::group
  $env      = 'production'
  $username = $name

  File {
    owner => $owner,
    group => $group,
  }

  file { $repo_dir:
    ensure => directory,
  }

  exec { "git::repo::init ${repo_dir}":
    command  => "git init --bare",
    creates  => "${repo_dir}/HEAD",
    cwd      => $repo_dir,
    user     => $owner,
    group    => $group,
  }

  file { "${repo_dir}/hooks/post-update":
    ensure   => 'present',
    mode     => 775,
    require  => Exec["git::repo::init ${repo_dir}"],
    content  => template('hrt/post-update.erb')
  }

  Package["git-core"] -> File[$repo_dir] -> Exec["git::repo::init $repo_dir"]

}
