node /\.com$/ inherits default {

  $user  = 'aliwal'
  $group = 'aliwal'
  $home  = "/data/ig/${user}"
  $dirs_aliwal = [ $home ]
  $dirs_root   = [ '/data', '/data/ig' ]
  $ruby_version = '2.1.2'

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

  # Apps #
  #exec { 'git-clone-aliwal':
  #  command => "su - aliwal -c 'git clone git@github.com:jondeandres/aliwal.git'",
  #  cwd     => $home,
  #  path    => ['/usr/bin', '/usr/sbin', '/bin'],
  #  require => [
  #    Package['git-core'],
  #    File[$dirs_aliwal]
  #  ]
  #}

  #exec { 'git-clone-whatsapp-service':
  #  command => "su - aliwal -c 'git clone git@github.com:jondeandres/whatsapp-service.git'",
  #  cwd     => $home,
  #  path    => ['/usr/bin', '/usr/sbin', '/bin'],
  #  require => [
  #    Package['git-core'],
  #    File[$dirs_aliwal]
  #  ]
  #}

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

  # PUMA #
  #TODO

  # PYTHON #
  package { 'python': ensure => installed }

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
    ensure => '1.5.0',
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

  rbenv::gem { 'unicorn':
    ensure => '4.8.3',
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
  monit::monitor { 'aliwal-unicorn':
    pidfile => "${home}/current/shared/pids/aliwal.pid",
  }

  # REDIS #
  include redis

  # MYSQL #
  include mysql::server
}
