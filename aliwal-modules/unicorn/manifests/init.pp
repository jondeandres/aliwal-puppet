define unicorn($user, $home, $app_name, $app_daemon, $env='development') {
  file { "/etc/init.d/${env}_${app_name}_${app_daemon}":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('unicorn/unicorn.erb'),
  }
}
