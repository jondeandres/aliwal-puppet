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

  $release_real = downcase($::lsbdistcodename)
  apt::source { 'backports-sloppy':
    location => $::apt::params::backports_location,
    release  => "${release_real}-backports-sloppy",
  }
  # Backports are needed before installing rbenv dependencies
  Apt::Source['backports-sloppy'] -> Class['rbenv::dependencies::ubuntu']

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
