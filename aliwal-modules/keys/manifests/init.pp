# Keys for aliwal user
class keys {
  if ! defined(User[$::user]) {
    user { $::user:
      ensure     => 'present',
      gid        => $::group,
      shell      => '/bin/bash',
      home       => $::home,
      managehome => true
    }
  }
  file {
    "${::home}/.ssh":
      ensure  => 'directory',
      owner   => $::user,
      group   => $::group,
      mode    => '0755',
      require => File[$::home];

    "${::home}/.ssh/id_dsa":
      ensure  => present,
      mode    => '0600',
      owner   => $::user,
      group   => $::group,
      source  => 'puppet:///modules/keys/id_dsa',
      require => File["${::home}/.ssh"];

    "${::home}/.ssh/id_dsa.pub":
      ensure  => present,
      mode    => '0600',
      owner   => $::user,
      group   => $::group,
      source  => 'puppet:///modules/keys/id_dsa.pub',
      require => File["${::home}/.ssh"];
  }
}
