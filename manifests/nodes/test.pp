node /\.com$/ inherits default {
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

  # Apps #
  exec { 'HostKeyGithub':
    command => "su - aliwal -c 'echo -e \"Host github.com\n\tStrictHostKeyChecking no\n\" >> ${home}/.ssh/config'",
    cwd     => $home,
    creates => "${home}/.ssh/config",
    path    => ['/usr/bin', '/usr/sbin', '/bin'],
    require => User[$user]
  }

  exec { 'git-clone-aliwal':
    command => "su - aliwal -c 'git clone git@github.com:jondeandres/aliwal.git'",
    cwd     => $home,
    creates => "${home}/aliwal",
    path    => ['/usr/bin', '/usr/sbin', '/bin'],
    require => [
      Package['git-core'],
      File["${home}/.ssh/id_dsa"],
      Exec['HostKeyGithub']
    ]
  }

  exec { 'git-clone-whatsapp-service':
    command => "su - aliwal -c 'git clone git@github.com:jondeandres/whatsapp-service.git'",
    cwd     => $home,
    creates => "${home}/whatsapp-service",
    path    => ['/usr/bin', '/usr/sbin', '/bin'],
    require => [
      Package['git-core'],
      File["${home}/.ssh/id_dsa"],
      Exec['HostKeyGithub']
    ]
  }

  exec { 'aliwal install':
    command => "su - aliwal -c 'cd ${home}/aliwal && bundle install'",
    path    => ['/usr/bin', '/usr/sbin', '/bin'],
    require => Exec['git-clone-aliwal'],
  }

  # APT #
  include apt::backports

  # ZMQ #
  package { 'libzmq3':
    ensure  => installed,
    require => Class['apt::backports']
  }

  # PYTHON #
  package { 'python': ensure => installed }
  package { 'python-dev': ensure => installed }
  package { 'python-pip': ensure => installed }
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

  rbenv::gem { 'bundler':
    ensure => '1.6.0',
    ruby   =>  $ruby_version,
    user   => $user,
    home   => $home
  }

  rbenv::gem { 'rainbows':
    ensure => '4.6.2',
    ruby   => $ruby_version,
    user   => $user,
    home   => $home
  }

  rbenv::gem { 'puma':
    ensure => '2.8.2',
    ruby   => $ruby_version,
    user   => $user,
    home   => $home
  }

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

  # MONIT #
  include monit
  monit::monitor { 'unicorn_development_aliwal':
    pidfile => "${home}/aliwal/tmp/pids/unicorn.pid"
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
    daemon => 'run.py'
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
}
