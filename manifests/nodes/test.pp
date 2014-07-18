node /\.com$/ inherits default {

  $user  = 'aliwal'
  $group = 'aliwal'
  $home  = "/data/ig/${user}"
  $dirs_aliwal = [ $home ]
  $dirs_root   = [ '/data', '/data/ig' ]

  #TODO app dirs structure - shared/logs
  file { $dirs_root:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755'
  }

  file { $dirs_aliwal:
    ensure => 'directory',
    owner  => $user,
    group  => $group,
    mode   => '0755'
  }

  # User & group #
  user { $user:
    ensure  => present,
    gid     => $group,
    home    => $home,
    shell   => '/bin/bash',
    require => Group[$group]
  }

  group { $group: ensure => present }

  # APT #
  include apt::backports

  file_line {
    'squezze-backports-sloppy':
      ensure => present,
      path   => '/etc/apt/sources.list',
      line   => 'deb http://http.debian.net/debian-backports squeeze-backports-sloppy main',
      #notify => Exec['apt_update']
  }

  # ZMQ #
  package { 'libzmq3':
    ensure  => installed,
    require => Class['apt::backports']
  }

  # PYTHON #
  package { 'python': ensure => installed }

  # RBENV #
  rbenv::install { $user:
    group => $group,
    home  => $home,
    require => Class['apt::backports'],
  }

  rbenv::compile { '2.1.2':
    user => $user,
    home => $home,
  }

  rbenv::gem { 'bundler':
    ensure => '1.5.0',
    ruby   => '2.1.2',
    user   => $user,
    home   => $home
  }

  # MONIT #
  include monit
  monit::monitor { 'aliwal-unicorn':
    pidfile => "${home}/current/shared/pids/aliwal.pid",
  }

  # REDIS #
  include redis
}
