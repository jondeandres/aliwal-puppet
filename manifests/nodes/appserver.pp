# temprary app server's fqdn
node 'kitt.kitt.cc' inherits default {
  $user  = 'aliwal'
  $group = 'aliwal'
  $home  = "/data/ig/${user}"
  $dirs_aliwal = [ $home ]
  $dirs_root   = [ '/data', '/data/ig' ]
  $ruby_version = '2.1.2'

  file { $dirs_root:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755'
  }

  #file { $dirs_aliwal:
  #  ensure => 'directory',
  #  owner  => $user,
  #  group  => $group,
  #  mode   => '0755'
  #}

  # User / group / keys #
  user { $user:
    ensure     => present,
    gid        => $group,
    home       => $home,
    shell      => '/bin/bash',
    managehome => 'true',
    require    => [
      Group[$group],
      File[$dirs_root]
    ]
  }

  group { $group: ensure => present }

  keys { 'aliwal-ssh-keys': home => $home }

  # APPS #
  class { 'git_utils':
    user => $user,
    home => $home,
  }

  $git_clone = {
    'aliwal' => {
      app            => 'aliwal',
      bundle_install => true
    },
    'whatsapp-service' => {
      app => 'whatsapp-service'
    }
  }
  $git_clone_defaults = {
    user => $user,
    home => $home
  }
  create_resources('git_utils::clone', $git_clone, $git_clone_defaults)

  # MONIT #
  # TODO apps & daemons at variables
  include monit
  monit::monitor { "aliwal-subscriber":
    pidfile => "${home}/aliwal/aliwal.pid"
  }
  monit::monitor { "whatsapp-service-run":
    pidfile => "${home}/whatsapp-service/whatsapp-service.pid"
  }

  # ZMQ #
  package { 'libzmq3':
    ensure  => installed,
    require => Class['apt::backports']
  }

  # PYTHON #
  class {'python':
    version    => 'system',
    pip        => true,
    dev        => true
  }
  python::pip { 'redis':
    pkgname       => 'redis',
  }
  python::pip { 'pyzmq':
    pkgname       => 'pyzmq',
  }
  python::pip { 'python-dateutil':
    pkgname       => 'python-dateutil',
  }
  python::pip { 'argparse':
    pkgname       => 'argparse',
  }
 
 # PACKAGES #
  package { 'libsqlite3-dev': ensure => installed }
  package { 'nodejs':
    ensure  => installed,
    require => Class['apt::backports']
  }

  # RBENV #
  rbenv::install { $user:
    group => $group,
    home  => $home,
  }

  rbenv::compile { $ruby_version:
    user => $user,
    home => $home,
  }

  $gems = {
    'bundler'  => { ensure => '1.6.5' },
    'rainbows' => { ensure => '4.6.2' },
    'puma'     => { ensure => '2.8.2' },
  }

  $gems_defaults = {
    user => $user,
    home => $home,
    ruby => $ruby_version
  }

  create_resources('rbenv::gem', $gems, $gems_defaults)

  file {"${home}/.ruby-version":
    content => $ruby_version,
    owner   => $user,
    group   => $group
  }

  file {"${home}/.bashrc":
    content => "source \$HOME/.rbenvrc",
    owner   => $user,
    group   => $group
  }

  # INIT.Ds #
  initscript::daemon { 'aliwal-subscriber':
    user   => $user,
    home   => $home,
    app    => 'aliwal',
    type   => 'ruby',
    daemon => 'subscriber'
  }

  initscript::daemon { 'whatsapp-service':
    user   => $user,
    home   => $home,
    app    => 'whatsapp-service',
    type   => 'python',
    daemon => 'run'
  }

  # PUMA
  class { 'puma':
    user  => $user,
    group => $group
  }

  # REDIS #
  include redis

  # MYSQL #
  include mysql::server

  # ENVIRONMENT VBLES #
  include environments
  environments::resources::profile { 'kitt': }
}
