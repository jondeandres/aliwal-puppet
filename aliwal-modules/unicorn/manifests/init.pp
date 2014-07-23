define unicorn($user, $home, $app_name=$name, $env='development') {
  file { "/etc/init.d/unicorn_${env}_${app_name}":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('unicorn/unicorn.erb'),
    notify  => Service["unicorn_${app_name}_${environment}"],
  }
}
