class puma ( $user, $group ){
  file { '/etc/init.d/puma':
    owner   => $user,
    group   => $group,
    replace => "yes",
    mode    => '0744',
    content => template('puma/puma-init.erb')
  }

  file { '/usr/local/bin/run-puma':
    owner  => $user,
    group  => $group,
    mode   => '0744',
    source => 'puppet:///modules/puma/run-puma'
  }

  file { '/etc/puma.conf' :
    owner   => $user,
    group   => $group,
    replace => "no",
    ensure  => "present",
    content => "",
    mode    => '0644'
  }
}
