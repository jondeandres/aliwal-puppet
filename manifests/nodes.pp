include base

node default {
  #TODO app dirs structure - shared/logs

  $home = '/data/ig/aliwal'

  user { 'aliwal':
    ensure => present,
    gid    => 'aliwal',
    home   => $home,
    shell  => '/bin/bash'
  }

  # ZMQ #
  package { 'libzmq3': ensure => installed }

  # PYTHON #
  package { 'python':  ensure => installed }

  # RBENV #
  rbenv::install { "aliwal":
    group => 'aliwal',
    home  => $home
  }

  rbenv::compile { "2.1.2":
    user => "aliwal",
    home => $home,
  }

  rbenv::gem { 'bundler_2.1.2':
    gemname       => 'bundler',
    gemversion    => '~>1.5.0',
    foruser       => 'aliwal',
    rubyversion   => '2.1.2';
  }

  # MONIT #
#  monit::monitor { 'aliwal-unicorn':
#    pidfile => "${home}/production/current/tmp/pid",
#    start_script => ,
#    stop_script => ,
#    checks =>
#  }
}
